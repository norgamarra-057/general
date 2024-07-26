# redis as a service

redislabs manual: https://confluence.groupondev.com/display/RED/redislabs+Manual

Directories:
* licenses: has all the license files we've got from Redislabs (see Redislabs manual)
* raas_api_caching: roller package base directory. Has a script that caches all redislabs API calls so multiple other scripts can read from local disk. Has a db configuration backup script. Goes in raas_mon hostclass
* raas_mon: roller package base directory with scripting to automate monitoring setup. Goes in raas_mon hostclass.
* redislabs_test_app: roller package base directory with a test-app script, happens to run on raas-mon hosts. Goes in raas_mon hostclass
* s3backups: AWS S3 buckets credentials and useful scripts to configure them (see Redislabs manual)
