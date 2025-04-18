import os
import pandas as pd

def get_files(directory):
    files = []
    for root, _, file_names in os.walk(directory):
        for file in file_names:
            if file.endswith((".xlsx", ".xls", ".csv")): 
                files.append(os.path.join(root, file))
    return files

def count_rows(file_path):
    try:
        if file_path.endswith(".csv"):
            df = pd.read_csv(file_path) 
        else:
            df = pd.read_excel(file_path, sheet_name=0, engine="openpyxl") 
        return len(df)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None 

def process_files(directory, output_file="cellcounts.csv"):
    files = get_files(directory)
    
    results = []
    for file in files:
        num_rows = count_rows(file)
        if num_rows is not None:
            results.append({"File Path": file, "Cell Count": num_rows})
    
    if results:
        df_results = pd.DataFrame(results)
        df_results.to_csv(output_file, index=False)
        print(f"Report saved to {output_file}")
    else:
        print("No valid files found.")


directory_path = "/Users/orphanlab/Downloads/240829_Counts" 
process_files(directory_path)
