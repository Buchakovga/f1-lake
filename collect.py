# %%

import pandas as pd
import fastf1
import argparse
import time


# %%
class CollectResults:
    
    def __init__(self, years=[2021,2022,2023], modes=["R","S"]):
        self.years=years
        self.modes=modes

    def get_data(self, year, gp, mode)->pd.DataFrame:
        
        try:
            session = fastf1.get_session(year, gp, mode)
        except ValueError as err:
            return pd.DataFrame()    
                      
        session._load_drivers_results()
        
        df = session.results
        df["mode"] = mode 
        
        return df

    def save_data(self, df, year, gp, mode):
        df.to_parquet(f"data/{year}_{gp:02}_{mode}.parquet")


    def process(self, year, gp, mode  ):
        df = self.get_data(year , gp, mode)
        if df.empty:
            return False
        self.save_data(df, year, gp, mode)
        return True
        
    def process_year_mode(self, year):
        for i in range(1, 50):
            for mode in self.modes:
                if not self.process(year, i, mode) and mode == "R":
                    return

    def process_year(self):
        for year in self.years:
            print(f"Coletando os dados do ano {year}")
            self.process_year_mode(year)
            time.sleep(10)
            


# %%


if __name__ == "__main__":


    parser = argparse.ArgumentParser()
    parser.add_argument("--years","-y", nargs="+", type=int)
    parser.add_argument("--modes","-m", nargs="+")
    
    args = parser.parse_args() 
    
    collect = CollectResults(args.years,args.modes)
    collect.process_year()

