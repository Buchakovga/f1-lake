
# %%

import dotenv
import os 
dotenv.load_dotenv()
import boto3
from botocore.exceptions import ClientError
from tqdm import tqdm
import argparse


# %% 


AWS_KEY = os.getenv("AWS_KEY")

AWS_SECRET_KEY = os.getenv("AWS_SECRET_KEY")


# %%


class sender:
    def __init__(self, bucket_name, bucket_folder):
        self.bucket_name = bucket_name
        self.bucket_folder = bucket_folder
        
        self.s3 = boto3.client("s3",
                    aws_access_key_id=AWS_KEY,
                    aws_secret_access_key=AWS_SECRET_KEY,
                    region_name="us-east-2")
    
    def process_file(self, filename):
      
        file = filename.split("/")[-1]
        bucket_path = os.path.join(self.bucket_folder, file)
        bucket_path = bucket_path.replace("\\", "/")
        bucket_path = bucket_path.replace("data/", "")
        try:
            self.s3.upload_file(filename,
                                self.bucket_name,
                                bucket_path
            )
        except Exception as e:
            print(e)        
            return False
    
        os.remove(filename)    
        return True
    
    def process_folder(self, folder):
        files = [i for i in  os.listdir(folder) if i.endswith(".parquet")]
        for f in tqdm(files):
            self.process_file(os.path.join(folder,f))
            
    
# %%

parser = argparse.ArgumentParser()
parser.add_argument("--bucket", type=str)
parser.add_argument("--bucket_path", type=str, default="f1/results")
parser.add_argument("--folder","-y", type=str, default="data")
args= parser.parse_args()

if args.bucket:
    send = sender(args.bucket, args.bucket_path)
    send.process_folder(args.folder)
else:
    print("Sem Bucket definido!")

# %%
