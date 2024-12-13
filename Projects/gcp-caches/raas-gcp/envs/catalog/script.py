import os
import hcl2
import json
import argparse
from itertools import product

def extract_inputs_from_hcl_files(base_folder):
    inputs_data = {}

    # Walk through the directory tree
    for root, _, files in os.walk(base_folder):
        for file in files:
            if file.endswith(".hcl"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r') as f:
                    try:
                        hcl_content = hcl2.load(f)
                        if 'inputs' in hcl_content:
                            folder_name = os.path.basename(root)
                            inputs_data[folder_name] = hcl_content['inputs']
                    except Exception as e:
                        print(f"Error parsing {file_path}: {e}")

    return inputs_data

import json

def load_json_file(file_path):
    try:
        with open(file_path, 'r') as file:
            data = json.load(file)
        return data
    except FileNotFoundError:
        print(f"Error: The file at {file_path} does not exist.")
    except json.JSONDecodeError:
        print(f"Error: The file at {file_path} is not a valid JSON file.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def join_dicts(inputs, cnames, prices):
    new_dict = {}
    inputs_clean = {key.replace('-cluster', '').replace('-memorystore', '').replace('-memcache', '').replace('-cloud', ''): value for key, value in inputs.items()}
    cnames_clean = {key.replace('-cluster', '').replace('-memorystore', '').replace('-memcache', '').replace('-cloud', ''): value for key, value in cnames.items()}

    for key in inputs_clean:
        new_dict[key] = {}
        if key in cnames_clean.keys():
            new_dict[key]["name"] = key
            new_dict[key]["region"] = cnames_clean[key]["cache_cname"].split('.')[1] if cnames_clean[key].get("cache_cname") else None
            new_dict[key]["env"] = cnames_clean[key]["cache_cname"].split('.')[3] if cnames_clean[key].get("cache_cname") else None
            new_dict[key]["service"] = inputs_clean[key]["labels"].get("tenantservice", None)

            if "memory_size" in inputs_clean[key] and inputs_clean[key]["memory_size"]:
                new_dict[key]["memory_size"] = inputs_clean[key]["memory_size"]
                new_dict[key]["type"] = inputs_clean[key]["labels"].get("service", None).replace('raas_', '')

            if "shard_count" in inputs_clean[key] and inputs_clean[key]["shard_count"]:
                new_dict[key]["shard_count"] = inputs_clean[key]["shard_count"]
                new_dict[key]["node_type"] = inputs_clean[key].get("node_type", None)
                new_dict[key]["replica_count"] = inputs_clean[key].get("replica_count", None)
                new_dict[key]["type"] = inputs_clean[key]["labels"].get("service", None).replace('raas_', '')

            if "cpu_count" in inputs_clean[key] and inputs_clean[key]["cpu_count"]: 
                new_dict[key]["memory_size"] = int(inputs_clean[key]["memory_size"] / 1024)
                new_dict[key]["cpu_count"] = inputs_clean[key].get("cpu_count", None)
                new_dict[key]["node_count"] = inputs_clean[key]["node_count"]
                new_dict[key]["type"] = inputs_clean[key]["labels"].get("service", None).replace('raas_', '')

            new_dict[key]["cache_cname"] = cnames_clean[key]["cache_cname"]
            new_dict[key]["cnames"] = cnames_clean[key]["cnames"][0].get("gcp_backend", None)
            new_dict[key]["jira_ticket"] = inputs_clean[key]["labels"].get("ticket", None)

    return new_dict

def save_to_json(data, output_file):
    directory = os.path.dirname(output_file)
    if not os.path.exists(directory):
        os.makedirs(directory) 

    with open(output_file, 'w') as f:
        json.dump(data, f, indent=4)
    print(f"Data successfully written to {output_file}")

def process_combination(env, region, engine):
    base_folder_inputs = f"../{env}/{region}"
    base_folder_inputs = os.path.join(base_folder_inputs, "memcache" if engine == "memcache" else "services")
    base_folder_cnames = f"../{env}/{region}/cnames"
    output_file_inputs = f"../catalog/catalog-web/data/{env}-{region}-{engine}.json"
    json_path_file = 'catalog-web/prices.json'

    inputs_dict = extract_inputs_from_hcl_files(base_folder_inputs)
    cnames_dict = extract_inputs_from_hcl_files(base_folder_cnames)
    price_dict = load_json_file(json_path_file)
    result = join_dicts(inputs_dict, cnames_dict, price_dict)
    result_clean = {key: value for key, value in result.items() if value} #Remove this line to debug any N/A issue and "result_clean" to "result" on the next line
    save_to_json(result_clean, output_file_inputs)

def main():
    parser = argparse.ArgumentParser(description="Extract inputs from HCL files and save to JSON.")
    parser.add_argument("env", nargs='?', choices=["prod", "stable"], help="Environment (prod or stable)")
    parser.add_argument("region", nargs='?', choices=["europe-west1", "us-central1"], help="Region (europe-west1 or us-central1)")
    parser.add_argument("engine", nargs='?', choices=["memcache", "redis"], help="Engine type (memcache or redis)")

    args = parser.parse_args()

    if args.env and args.region and args.engine:
        process_combination(args.env, args.region, args.engine)
    else:
        environments = ["prod", "stable"]
        regions = ["europe-west1", "us-central1"]
        engines = ["memcache", "redis"]

        for env, region, engine in product(environments, regions, engines):
            print(f"Processing: env={env}, region={region}, engine={engine}")
            process_combination(env, region, engine)

if __name__ == "__main__":
    main()
