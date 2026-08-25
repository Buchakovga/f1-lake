

# %%

import datetime
import os 
from collect import CollectResults
from sender import sender
import dotenv
dotenv.load_dotenv(override=True)
BUCKET_NAME = os.getenv("BUCKET_NAME")

# %% 

print("coletando dados...")
#collect_data = CollectResults(years=[datetime.datetime.now().year])
collect_data = CollectResults(years=[1993,1992,1991,1990])
collect_data.process_year()


# %%

print("Enviando dados para o bucket S3...")
sender_data = sender(bucket_name=BUCKET_NAME, bucket_folder="f1/results")
sender_data.process_folder("data")

# %%

