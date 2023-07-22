import requests
import pandas as pd


def check_assembled(samples):
    assembled_samples = {}

    for sample_id in samples:
        url = f"https://api.mg-rast.org/metagenome/{sample_id}.3/metadata?verbosity=full"
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()
            assembled = data.get("pipeline_parameters", {}).get("assembled")
            if assembled == "yes":
                assembled_samples[sample_id] = "yes"
            else:
                assembled_samples[sample_id] = "no"
        else:
            print(f"Error fetching metadata for sample {sample_id}: {response.status_code}")
            assembled_samples[sample_id] = "error"

        # Convert the dictionary to a DataFrame
        assembled_df = pd.DataFrame.from_dict(assembled_samples, orient='index', columns=["assembled"])

        # Save the DataFrame as a CSV file after each sample is processed
        assembled_df.to_csv("assembled_samples.csv")

    return assembled_samples

if __name__ == "__main__":
    metadata = pd.read_csv("final_metadata/final_biome_classification.csv")
    sample_list = metadata["samples"].tolist()
    assembled_samples = check_assembled(sample_list)

    print("Samples with 'assembled' set to 'yes':", assembled_samples)