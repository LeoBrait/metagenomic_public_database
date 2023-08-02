import os
import aiohttp
import asyncio
import pandas as pd
import random
import json

async def download_sample_metadata(session, sample_id):
    url = (
        "https://api.mg-rast.org/"
            f"metagenome/{sample_id}.3/metadata?verbosity=full&asynchronous=1"
    )

    # Check if the metadata file already exists
    if os.path.exists("treating_data/01_original_data/mgrast_json/"
                        f"{sample_id}_metadata.json"):
        print(
            f"Metadata for sample {sample_id} already downloaded. Skipping..."
        )
        return None

    # Introduce a random delay between intervals
    delay = random.uniform(6, 7)
    await asyncio.sleep(delay)

    async with session.get(url) as response:
        if response.status == 200:
            json_data = await response.json()
            return json_data
        elif response.status == 429:

            retry_after = int(response.headers.get("Retry-After", "15"))
            print(
                f"Received 429 status code."
                  f"Retrying after {retry_after} seconds..."
            )
            await asyncio.sleep(retry_after)
            return await download_sample_metadata(session, sample_id)
        else:
            print(
                f"Failed to download metadata for sample {sample_id}." 
                   f"Status code: {response.status}"
            )
            return None

async def download_samples(sample_ids):
    async with aiohttp.ClientSession() as session:
        tasks = [download_sample_metadata(session, sample_id) \
                 for sample_id in sample_ids]
        results = await asyncio.gather(*tasks)

        for sample_id, json_data in zip(sample_ids, results):
            if json_data:
                
                with open(
                    "treating_data/01_original_data/mgrast_json/"
                        f"{sample_id}_metadata.json",
                    "w"
                ) as outfile:
                    json.dump(json_data, outfile)
                    print(f"Metadata for sample {sample_id} downloaded.")

async def main():
    # Replace this list with your actual list of sample IDs
    sample_ids = sample_list

    # Divide the sample IDs into 10 chunks for parallel requests
    chunks = [sample_ids[i:i + 6] for i in range(0, len(sample_ids), 6)]

    try:
        loop = asyncio.get_running_loop()
    except RuntimeError:  # No running event loop
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)

    for chunk in chunks:
        
        try:
            await download_samples(chunk)
        
        except (aiohttp.ClientConnectionError, aiohttp.ServerDisconnectedError):
            print("Disconnected. Restarting after 1 minute...")
            await asyncio.sleep(60)
            continue

if __name__ == "__main__":
    metadata = pd.read_csv(
        "treating_data/01_original_data/mgrast_raw.csv", sep=";"
    )
    sample_list = metadata["sample"].tolist()
    asyncio.run(main())