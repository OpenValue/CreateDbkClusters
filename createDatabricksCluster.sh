#! /bin/bash
set -e


usage()
{
    echo "usage: createDatabricksCluster [[-p profile ] -u username] | [-h]]"
}

### main
profile=""
while [ "$1" != "" ]; do
    case $1 in
        -u | --username )       shift
                                username=$1
                                ;;
        -p | --profile )    	shift
				profile="--profile $1 "
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done


 echo "====>${username}"
 echo "====>${profile}"


if [ -z "$username" ];
then
	echo "A username must be set"
	usage
	exit 1
fi	


clusterDef="{
    \"num_workers\": 1,
    \"cluster_name\": \"small_cluster_${username}\",
    \"spark_version\": \"7.3.x-scala2.12\",
    \"spark_conf\": {
        \"spark.databricks.passthrough.enabled\": \"true\"
    },
    \"node_type_id\": \"Standard_DS3_v2\",
    \"ssh_public_keys\": [],
    \"custom_tags\": {},
    \"spark_env_vars\": {
        \"PYSPARK_PYTHON\": \"/databricks/python3/bin/python3\"
    },
    \"autotermination_minutes\": 20,
    \"cluster_source\": \"UI\",
    \"init_scripts\": [],
    \"single_user_name\": \"${username}\""




databricks ${profile}clusters  create --json "${clusterType}"
