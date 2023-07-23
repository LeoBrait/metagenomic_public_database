# Author: Eduardo HC Galvao - eduardohcgalvao@gmail.com
# Version: 2.0 (2023/02/28)
# Created: 2022/10/13

## Usage: python3 download_MG-RAST_metadata.py INPUT_FILE OUTPUT_FILE_NAME

## From a given one column input file with the list of the MG-RAST samples IDs,
## use the "urllib.request.urlopen" to tabulate in a output file
## the raw metadata in JSON format from the MG-RAST api.

## INPUT_FILE ==> One column file with the metagenomes IDs for request download.

## OUTPUT_FILE_NAME ==> Name for the given output file.

import os, sys, datetime, time, urllib.request, json

# Assign the input_file and the output_table name.
input_file = sys.argv[1]
output_table = sys.argv[2]

# Function to get time for log file.
def update_time():
    now = datetime.datetime.now()
    current_time = now.strftime("%H:%M:%S")
    return current_time

# Function to acess MG-RAST api and extract sample metadata.
def acess_mg_rast_api(metagenome_api_url):
    try:
        with urllib.request.urlopen(metagenome_api_url) as mgrast_api_metadata:
            raw_metadata = mgrast_api_metadata.read()
    except:
        time.sleep(180)
        with urllib.request.urlopen(metagenome_api_url) as mgrast_api_metadata:
            raw_metadata = mgrast_api_metadata.read()
    return raw_metadata

# Function to parse the information in the JSON format and annotate output.
def annotate_output(raw_metadata, output_table):
    metadata_dict = json.loads(raw_metadata.decode('UTF-8'))
    with open(output_table, "a+") as output:
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["biome"]).replace(";", ",").replace("\n", "_") + ";" )
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["feature"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["material"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["env_package"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["metagenome_taxonomy"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["library"]["data"]["metagenome_name"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["project_name"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["project_description"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["project_description"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["project_description"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["library"]["data"]["investigation_type"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["mixs"]["sequence_type"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["collection_date"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["collection_date"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["continent"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["country"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["latitude"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["sample"]["data"]["longitude"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["PI_organization"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["PI_organization_address"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["PI_organization_country"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["PI_firstname"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["PI_lastname"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["project"]["data"]["PI_email"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        try:
            output.write(str(metadata_dict["metadata"]["env_package"]).replace(";", ",").replace("\n", "_") + ";")
        except:
            output.write("METADATA_NOT_AVAILABLE;")
        output.write("\n")
    return

# Function to print current loading progress in Download.
def calculate_loading(count, total):
    load = int(count)/int(total)
    load_percentage = float(load)*100
    return float(load_percentage)

# Function to open the input file and retrieve a dict with the metagenome ids.
def get_metagenomes_id_dict(input_file):
    current_time = update_time()
    print(current_time + " - Reading input_file metagenomes IDs.")
    metagenomes_ids_dict = {}
    mg_rast_api_url = "https://api.mg-rast.org/metagenome/"
    metadata_url = ".3/metadata?verbosity=full"
    with open(input_file, 'r') as file:
        lines = file.readlines()
        for line in lines:
            formated_line = str(line).replace("\n", "")
            metagenome_metadata_url = mg_rast_api_url + formated_line + metadata_url
            metagenomes_ids_dict[formated_line] = metagenome_metadata_url
    return metagenomes_ids_dict

def main(input_file, output_table):
    # Send a terminal signal for the start of the script.
    current_time = update_time()
    print(current_time + " - START!\n")

    # Call the function to get metagenomes ID dict from input file.
    # If the input file was miscalled, then raise error.
    try:
        metagenomes_ids_dict = get_metagenomes_id_dict(input_file)
    except:
        raise TypeError("Input file was read incorrectly")

    loading_total_metagenomes = int(len(metagenomes_ids_dict))
    loading_count = 0
    for metagenome in metagenomes_ids_dict:
        current_time = update_time()
        print(current_time + " - Downloading metadata for " + str(metagenome))
        loading_count += 1
        loading = calculate_loading(loading_count, loading_total_metagenomes)
        print(current_time + " - " + str(round(loading, 2)) + "% Concluded." +
        str(loading_count) + " of " + str(loading_total_metagenomes))

        # For each listed metagenome, run the functions to get MG-RAST metadata.
        # If not succeeded the function sleeps for 3 minutes and retry.
        # If there ain't metadata available then write NA on results and pass.
        try:
            raw_metadata = acess_mg_rast_api(metagenomes_ids_dict[metagenome])
        except:
            current_time = update_time()
            print(current_time + " - Metadata not available.")
            raw_metadata = "metadata_not_available"
            with open(output_table, "a+") as output:
                output.write(raw_metadata + "\n")
            pass

        # Parse raw_metadata and annotate output.
        annotate_output(raw_metadata, output_table)

    # Send a terminal signal for the end of the script.
    current_time = update_time()
    print("\n" + str(current_time) + " - END!")
    return

if __name__ == "__main__":
    main(input_file, output_table)
