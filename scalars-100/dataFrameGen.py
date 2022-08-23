import pandas as pd
import os
if not os.path.exists('csvData'):
    os.mkdir('csvData')

dfPaths = pd.read_csv("./dataPaths", header=None, index_col=0, delim_whitespace=True)
dfPaths = dfPaths.transpose()

dataTypes = dfPaths.columns  
print(dataTypes)
dataframes={}
for dataType in dataTypes:
    tempDF = pd.DataFrame()
    for num, path in enumerate(dfPaths[dataType].values):
        print(path)
        dataset = pd.read_csv(path, delim_whitespace=True)
        dataset["#file"] = [name.split(".")[0] for name in dataset["#file"].values]
        dataset.set_index("#file")
        tempDF = pd.concat([tempDF,dataset])

    tempDF.to_csv("csvData/{}.csv".format(dataType))
    # print(tempDF)

