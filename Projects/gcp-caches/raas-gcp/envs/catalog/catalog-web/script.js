let allData = [];
let priceData = {};
let linksData = {};

// Add event listeners for filters
document.getElementById('region-filter').addEventListener('change', function() {
    filterTable(); // Call filterTable on change without passing arguments
});
document.getElementById('type-filter').addEventListener('change', function() {
    filterTable(); // Call filterTable on change without passing arguments
});
document.getElementById('env-filter').addEventListener('change', function() {
    filterTable(); // Call filterTable on change without passing arguments
});

// Function to filter and generate the table based on the selected filters
function filterTable() {
    const regionFilter = document.getElementById('region-filter').value.toLowerCase();
    const typeFilter = document.getElementById('type-filter').value.toLowerCase();
    const envFilter = document.getElementById('env-filter').value.toLowerCase();

    console.log("Filters - Region: ", regionFilter, " Type: ", typeFilter, " Env: ", envFilter);  // Debugging log

    const filteredData = allData.filter(entry => {
        let matches = true;
        // Filter out entries where name is 'N/A'
        if (entry.name === 'N/A') {
            matches = false;
        }

        // Filter by region
        if (regionFilter && entry.region && !entry.region.toLowerCase().includes(regionFilter)) {
            matches = false;
        }

        // Filter by type
        if (typeFilter && entry.type && !entry.type.toLowerCase().includes(typeFilter)) {
            matches = false;
        }

        // Filter by env
        if (envFilter && entry.env && !entry.env.toLowerCase().includes(envFilter)) {
            matches = false;
        }

        return matches;
    });

    generateTable(filteredData, priceData, linksData);  // Re-generate table with filtered data
}

// Fetch all data
async function fetchData() {
    try {
        const dataArrays = await Promise.all(
            jsonFiles.map(file =>
                fetch(file).then(response => {
                    if (!response.ok) {
                        throw new Error(`Error loading file ${file}: ${response.statusText}`);
                    }
                    return response.json(); // Parse the JSON data
                })
            )
        );

        const fetchedPriceData = await fetch(pricesFile)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error loading price file ${pricesFile}: ${response.statusText}`);
            }
            return response.json(); // Parse the price JSON data
        });

        const fetchedLinksData = await fetch(linksFile)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error loading price file ${linksFile}: ${response.statusText}`);
            }
            return response.json(); // Parse the price JSON data
        });

        allData = dataArrays.flatMap(data => Object.values(data)); // Flatten all the data files
        priceData = fetchedPriceData;
        linksData = fetchedLinksData;

        generateTable(allData, priceData); // Initial table generation
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

// List of all JSON file paths relative to script.js (excluding the new JSON with prices)
const jsonFiles = [
    'data/prod-europe-west1-memcache.json',
    'data/prod-europe-west1-redis.json',
    'data/prod-us-central1-memcache.json',
    'data/prod-us-central1-redis.json',
    'data/stable-europe-west1-memcache.json',
    'data/stable-europe-west1-redis.json',
    'data/stable-us-central1-memcache.json',
    'data/stable-us-central1-redis.json'
];

// Path to the new JSON file with prices
const pricesFile = 'prices.json';
const linksFile = 'links.json';

Promise.all([
    // Fetch the other JSON files (without prices)
    Promise.all(
        jsonFiles.map(file => 
            fetch(file)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`Error loading file ${file}: ${response.statusText}`);
                    }
                    return response.json(); // Parse the JSON data
                })
                .catch(error => {
                    console.error('Error:', error);
                    return {}; // Return an empty object on error to avoid breaking the loop
                })
        )
    ),
    // Fetch the price JSON file separately
    fetch(pricesFile)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error loading price file ${pricesFile}: ${response.statusText}`);
            }
            return response.json(); // Parse the price JSON data
        })
        .catch(error => {
            console.error('Error loading price file:', error);
            return {}; // Return an empty object on error
        }),

    fetch(linksFile)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error loading price file ${linksFile}: ${response.statusText}`);
            }
            return response.json(); // Parse the price JSON data

        })
        .catch(error => {
            console.error('Error loading price file:', error);
            return {}; // Return an empty object on error
        }
    )
]).then(([dataArrays, fetchedPriceData, fetchedLinksData]) => {
    // Flatten the object data into an array of entries (for the main JSON files)
    allData = dataArrays.flatMap(data => {
        return Object.values(data); // Flatten each file's object into an array of service entries
    });

    // Store the price data
    priceData = fetchedPriceData;
    linksData = fetchedLinksData;

    // Generate the table with the main data
    generateTable(allData, priceData, linksData);  // Ensure the table is generated initially
}).catch(error => console.error('Error fetching data:', error));


// Function to calculate the Tier according to memory size
function getNodeType(memory_size) {
    if (memory_size >= 1 && memory_size <= 4) return 'M1';
    if (memory_size >= 5 && memory_size <= 10) return 'M2';
    if (memory_size >= 11 && memory_size <= 35) return 'M3';
    if (memory_size >= 36 && memory_size <= 100) return 'M4';
    if (memory_size > 100 && memory_size < 1000) return 'M5';
}

// Function to calculate the capacity based on node type and shard count
function getCapNodeType(node_type, shard_count) {
    if (node_type === 'REDIS_SHARED_CORE_NANO') return (shard_count * 1.12).toFixed(2);
    if (node_type === 'REDIS_STANDARD_SMALL') return (shard_count * 5.2).toFixed(2);
    if (node_type === 'REDIS_HIGHMEM_MEDIUM') return (shard_count * 10.4).toFixed(2);
    if (node_type === 'REDIS_HIGHMEM_XLARGE') return (shard_count * 46.4).toFixed(2);
    return 'N/A';
}

function getPricing(priceData, region, type, nodeType, tier, memorySize, shardCount, nodeCount) {
    // Check if the price exists for the given region, type, and tier (Redis Instances)
    if (priceData[region] && priceData[region][type] && priceData[region][type][tier]) {
        return (priceData[region][type][tier] * memorySize * 730).toFixed(2);
    }

    // Check for Redis Clusters (by nodeType)
    if (priceData[region] && priceData[region][type] && priceData[region][type][nodeType]) {
        return (priceData[region][type][nodeType] * shardCount * 730).toFixed(2);
    }

    // Check for Memcache pricing based on memorySize
    if (priceData[region] && priceData[region][type]) {
        if (memorySize <= 4) {
            return (priceData[region][type]['node<=4'] * memorySize * nodeCount * 730).toFixed(2) || 'N/A';  // Fallback if the 'node<=4' pricing doesn't exist priceData[region][type]['node<=4']
        } else {
            return (priceData[region][type]['node>4'] * memorySize * nodeCount * 730).toFixed(2) || 'N/A';  // Fallback if the 'node>4' pricing doesn't exist
        }
    }

    // Fallback if no valid pricing is found
    return 'N/A';
}

function getLink(linksData, env, region, type, name) {
    // Check if the price exists for the given region, type, and tier (Redis Instances)
    if (linksData[env] && linksData[env][region] && linksData[env][region][type] && linksData[env][region][type][name]) {
        return linksData[env][region][type][name];
    }
}

// Function to generate the table
function generateTable(data, priceData, linksData) {
    const tableBody = document.getElementById('table-body');
    let rowsHTML = '';

    for (const entry of data) {
        const memorySize = entry.memory_size || 0;
        const nodeType = entry.node_type || '';
        const nodeCount = entry.node_count || ''; 
        const type = entry.type || ''; 
        const region = entry.region || '';
        const env = entry.env || ''; 
        const name = entry.name || '';  
        const shardCount = entry.shard_count || 0;
        const instanceType = getNodeType(memorySize);
        const capacity = getCapNodeType(nodeType, shardCount);
        const price = getPricing(priceData, region, type, nodeType, instanceType, memorySize, shardCount, nodeCount);
        const link = getLink(linksData, env, region, type, name);

        rowsHTML += `
            <tr>
                <td>${entry.name || 'N/A'}</td>
                <td>${entry.region || 'N/A'}</td>
                <td>${entry.type || 'N/A'}</td>
                <td>
                    ${entry.service ? `<a href="https://services.groupondev.com/services/${entry.service}" target="_blank">${entry.service}</a>` : 'N/A'}
                </td>
                <td>${nodeType || instanceType || '-'}</td>
                <td>${shardCount || nodeCount || '-'}</td>
                <td>${memorySize || capacity || 'N/A'}</td>
                <td>${entry.cache_cname || 'N/A'}</td>
                <td>
                    ${entry.jira_ticket ? `<a href="https://jira.groupondev.com/browse/${entry.jira_ticket}" target="_blank">${entry.jira_ticket}</a>` : 'N/A'}
                </td>
                <td>${price || 'N/A'}</td>
                <td>
                    ${link ? `<a href="${link}" target="_blank">Link</a>` : 'N/A'}
                </td>
            </tr>
        `;
    }

    tableBody.innerHTML = rowsHTML;
}

// Fetch and load data
fetchData();
