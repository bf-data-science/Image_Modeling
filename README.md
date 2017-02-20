# Image_Modeling
Files and Code associated with the Image Modeling project - started Feb 2017

# Recreating APA Tool for PAR

## Background
To help facilitate build of the global pricing and revenue tool (PAR), we recreated the automated pricing analysis tool (APA) build by Patrick Andrade. To do this, we gathered market-level data for `US Open Markets`, `US Control Markets`, `UK Total`, and `AU Total` with the goal of adding more over time.

Within each of these markets, we are collecting volume and price for JDTW and its respective category. In the future, we will add this data for all other brands and their respective categories as well. This data is the foundation of the APA algorithm methodology.

At the end of the process, we built the APA information in the [the PAR dashboard](https://us-east-1.online.tableau.com/t/bfdatascience/views/USPricingAnalyticsRevenueMaximizationDashboard/PricingStory?:embed=y&:showShareOptions=true&:display_count=no&:showVizHome=no)

## Methodology

### US Open Markets
<hr>
#### Directory Layout
To organize the project, the US Open Markets directory has been structured to warehouse specific sections of the process: `data` | `model` | `results` which each subdirectory holding files dedicated to the overall project.

```
us-nielsen
|-- data
	|-- total-jack-data.Rds
	|-- total-market-list.csv
|-- model
	|-- recreate-nielsen-apa.Rmd
|-- results
	|-- nielsen-data-jdtw-apa-oldmethod.csv
	|-- nielsen-data-jdtw-weeklyvols-oldmethod.csv

```

**data**
<br>
**`total-jack-data.Rds`** is a serialized R data object housing all of the weekly data for volume and price for every brand and size across every market. This data is built based on the specifications in the [Data Feed](#data-feed) section.

**`total-market-list.csv`** is a csv file specifying which of the Nielsen markets we are pulling data for. These markets represent lowest-level markets where the accounts service a single state and their geographies do not cross state lines.

**model**
<br>
**`recreate-nielsen-apa.Rmd`** is an Rmarkdown document storing the script used to pull in **`total-jack-data.Rds`** and **`total-market-list.csv`** and apply the [APA algorithm](#us-open-market-apa-algorithm) against. 

This script also includes a sandbox component to it where newer methodologies are being tested for seasonalization calculations and price adjustments. Should any of these methods develop further, a new script will be added focusing solely on the application of the new algorithms, and the methodology section here will be updated reflecting that. 

**results**
<br>
**`nielsen-data-jdtw-apa-oldmethod.csv`** is a csv file warehousing the results of the APA algorithm for every market from **`total-market-list.csv`**. Currently, this data only reflects JDTW 750ml and 1.75l. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`nielsen-data-jdtw-weeklyvols-oldmethod.csv`** is a csv file storing adjusted weekly price and normalized volume levels for every market. Currently, this data only reflects JDTW 750ml and 1.75l. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

##### **US Open Market APA Algorithm**
The APA algorithm for the US Open Markets takes weekly-level volume and adjusts it based on the relevant categories performance for that same week against the average of all weeks for the category. If the week is typically strong for the category, then the brand's volume for that week will be reduced (e.g. holiday periods). The opposite is true for weeks where category volume is below average, which will increase that week's volume for the brand.

Then, we round the average price to its nearest $0.99 price point - either up if it is above $0.50 or below if it is under $0.50 (for example, $14.49 gets rounded down to $13.99 and $14.51 gets rounded up to $14.99). This better reflects true price points for the week as opposed to Nielsen's raw average price.

Based on these price points, we then build the APA table showing the rounded price point, the average weekly volume at that price point, and the average weekly dollar sales at the price point for each of the markets in **`total-market-list.csv`**. Currently, this data only reflects JDTW 750ml and 1.75l. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

### US Control Markets
<hr>
#### Directory Layout
To organize the project, the US Control Markets directory has been structured to warehouse specific sections of the process: `data` | `model` | `results` which each subdirectory holding files dedicated to the overall project.

```
us-nabca
|-- data
	|-- markup.csv
	|-- nh-data.csv
	|-- pa-data.csv
	|-- total-jack-data-nabca.Rds
|-- model
	|-- recreate-nabca-apa.Rmd
	|-- recreate-pa-nabca-apa.Rmd
	|-- recreate-nh-nabca-apa.Rmd
|-- results
	|-- nabca-data-jdtw-apa-oldmethod.csv
	|-- nabca-pa-data-jdtw-apa-oldmethod.csv
	|-- nabca-nh-data-jdtw-apa-oldmethod.csv
	|-- nabca-data-jdtw-weeklyvols-oldmethod.csv
	|-- nabca-pa-data-jdtw-weeklyvols-oldmethod.csv
	|-- nabca-nh-data-jdtw-weeklyvols-oldmethod.csv

```

**data**
<br>
**`total-jack-data-nabca.Rds`** is a serialized R data object housing all of the monthly data for volume and price for every size of JDTW across every control state market. This data is built based on the specifications in the [Data Feed](#data-feed) section.

**`pa-data.csv`** is a csv file specifying the same data as above, but at a weekly level and specific only to the state of PA. The data collected here is done through a process separate from the **`total-jack-data-nabca.Rds`** file.

**`nh-data.csv`** is a csv file specifying the same data as above, but at a weekly level and specific only to the state of NH. The data collected here is done through a process separate from the **`total-jack-data-nabca.Rds`** file.

**`markup.csv`** is a csv file outlining the markup that needs to be applied to the reported shelf price for each size in a handful of states. The process for applying these markups is defined in the [APA algorithm](#us-control-market-apa-algorithm).

**model**
<br>
**`recreate-nabca-apa.Rmd`** is an Rmarkdown document storing the script used to pull in **`total-jack-data-nabca.Rds`** and **`markup.csv`** and apply the [APA algorithm](#us-control-market-apa-algorithm) against. 


**`recreate-pa-nabca-apa.Rmd`** is an Rmarkdown document storing the script used to pull in **`pa-data.csv`** and apply the APA algorithm against. 

**`recreate-nh-nabca-apa.Rmd`** is an Rmarkdown document storing the script used to pull in **`nh-data.csv`** and apply the APA algorithm against. 

Each of these scripts include a sandbox component where newer methodologies are being tested for seasonalization calculations and price adjustments. Should any of these methods develop further, a new set of scripts will be added focusing solely on the application of the new algorithms, and the methodology section here will be updated reflecting that. 

**results**
<br>
**`nabca-data-jdtw-apa-oldmethod.csv**` is a csv file warehousing the results of the APA algorithm for every control market. Currently, this data only reflects JDTW across all sizes. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`nabca-pa-data-jdtw-apa-oldmethod.csv**` is a csv file warehousing the results of the APA algorithm for PA. Currently, this data only reflects JDTW across all sizes. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`nabca-nh-data-jdtw-apa-oldmethod.csv**` is a csv file warehousing the results of the APA algorithm for NH. Currently, this data only reflects JDTW across all sizes. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`nabca-data-jdtw-weeklyvols-oldmethod.csv**` is a csv file storing adjusted monthly price and normalized volume levels for every control market. Currently, this data only reflects JDTW across all sizes. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`nabca-pa-data-jdtw-weeklyvols-oldmethod.csv**` is a csv file storing adjusted weekly price and normalized volume levels for PA. Currently, this data only reflects JDTW across all sizes. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`nabca-nh-data-jdtw-weeklyvols-oldmethod.csv**` is a csv file storing adjusted weekly price and normalized volume levels for NH. Currently, this data only reflects JDTW across all sizes. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

##### **US Control Market APA Algorithm**
The APA algorithm for the US Control Markets outside of PA and NH takes monthly-level volume and adjusts it based on the relevant categories performance for that same month against the average of all months for the category. If the month is typically strong for the category, then the brand's volume for that month will be reduced (e.g. holiday periods). The opposite is true for months where category volume is below average, which will increase that month's volume for the brand.

Then, we round the average price to its nearest $0.49 price point - either up if it is above $0.25 but under $0.75 or down if it is above $0.75 but under $0.25 (for example, $14.30 gets rounded down to $13.99 and $14.80 gets rounded up to $14.99). This better reflects true price points for the month as opposed to Nielsen's raw average price.

Based on these price points, we then build the APA table showing the rounded price point, the average monthly volume at that price point, and the average monthly dollar sales at the price point for each of the US control states. Currently, this data only reflects JDTW but covers 50ml, 100ml, 200ml, 375ml, 750ml, 1L, and 1.75L. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

The same methodology above is used for PA and NH, with the exception being that these control markets are weekly versus monthly. All reporting in the APA is reflective of weekly averages and results.

### AU Total Market
<hr>
#### Directory Layout
To organize the project, the AU Total Market directory has been structured to warehouse specific sections of the process: `data` | `model` | `results` which each subdirectory holding files dedicated to the overall project.

```
au-total
|-- data
	|-- total-au-data.csv
	|-- total-au-data.Rds
|-- model
	|-- build-au-apa.Rmd
|-- results
	|-- au-data-jdtw-apa-oldmethod.csv
	|-- au-data-jdtw-weeklyvols-oldmethod.csv
```

**data**
<br>
**`total-au-data.Rds`** is a serialized R data object housing all of the weekly data for volume and price for every size of all brands across Australia's six customers. This data is built based on the specifications in the [Data Feed](#data-feed) section.

**`total-au-data.csv`** is a csv file specifying the same data as above, but with some cleanup done on the data formatting to allow calculations.

**model**
<br>
**`build-au-apa.Rmd`** is an Rmarkdown document storing the script used to pull in **`total-au-jack-data.Rds`** and apply the [APA algorithm](#au-total-market-apa-algorithm) against. 

The script also includes a sandbox component where newer methodologies are being tested for seasonalization calculations and price adjustments. Should any of these methods develop further, a new script will be added focusing solely on the application of the new algorithms, and the methodology section here will be updated reflecting that. 

**results**
<br>
**`au-data-jdtw-apa-oldmethod.csv**` is a csv file warehousing the results of the APA algorithm for every customer in AU. Currently, this data only reflects JDTW 700ml and 1l. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`au-data-jdtw-weeklyvols-oldmethod.csv**` is a csv file storing adjusted weekly price and normalized volume levels for each AU customer. Currently, this data only reflects JDTW 700ml and 1L. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

##### **AU Total Market APA Algorithm**
The APA algorithm for the AU Total Market takes weekly volume and adjusts it based on the relevant categories performance for that same week against the average of all weeks for the category. If the week is typically strong for the category, then the brand's volume for that week will be reduced (e.g. holiday periods). The opposite is true for weeks where category volume is below average, which will increase that week's volume for the brand.

Then, we round the average price to its nearest $0.99 price point - either up if it is above $0.50 or below if it is under $0.50 (for example, $14.49 gets rounded down to $13.99 and $14.51 gets rounded up to $14.99). This better reflects true price points for the week as opposed to Aztec's raw average price.

Based on these price points, we then build the APA table showing the rounded price point, the average weekly volume at that price point, and the average weekly dollar sales at the price point for each of the six customers in AU. Currently, this data only reflects JDTW 700ml and 1l. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

### UK Total Market
<hr>
#### Directory Layout
To organize the project, the UK Total Market directory has been structured to warehouse specific sections of the process: `data` | `model` | `results` which each subdirectory holding files dedicated to the overall project.

```
uk-total
|-- data
	|-- total-uk-data.csv
	|-- total-uk-data.Rds
|-- model
	|-- build-uk-apa.Rmd
|-- results
	|-- uk-data-jdtw-apa-oldmethod.csv
	|-- uk-data-jdtw-weeklyvols-oldmethod.csv
```

**data**
<br>
**`total-uk-data.Rds`** is a serialized R data object housing all of the weekly data for volume and price for every size of all brands across all markets in the UK. This data is built based on the specifications in the [Data Feed](#data-feed) section.

**`total-uk-data.csv`** is a csv file specifying the same data as above, but with some cleanup done on the data formatting to allow calculations.

**model**
<br>
**`build-uk-apa.Rmd`** is an Rmarkdown document storing the script used to pull in **`total-uk-jack-data.Rds`** and apply the [APA algorithm](#uk-total-market-apa-algorithm) against. 

The script also includes a sandbox component where newer methodologies are being tested for seasonalization calculations and price adjustments. Should any of these methods develop further, a new script will be added focusing solely on the application of the new algorithms, and the methodology section here will be updated reflecting that. 

**results**
<br>
**`uk-data-jdtw-apa-oldmethod.csv**` is a csv file warehousing the results of the APA algorithm for every market in the UK. Currently, this data only reflects JDTW 700ml and 1l. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

**`uk-data-jdtw-weeklyvols-oldmethod.csv**` is a csv file storing adjusted weekly price and normalized volume levels for each UK market. Currently, this data only reflects JDTW 700ml and 1L. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

##### **UK Total Market APA Algorithm**
The APA algorithm for the UK Total Market takes weekly volume and adjusts it based on the relevant categories performance for that same week against the average of all weeks for the category. If the week is typically strong for the category, then the brand's volume for that week will be reduced (e.g. holiday periods). The opposite is true for weeks where category volume is below average, which will increase that week's volume for the brand.

Then, we round the average price to its nearest price point - either up if it is above $0.50 or below if it is under $0.50 (for example, 14.49 gets rounded down to 14 and 14.51 gets rounded up to 15). This better reflects true price points for the week as opposed to Aztec's raw average price.

Based on these price points, we then build the APA table showing the rounded price point, the average weekly volume at that price point, and the average weekly dollar sales at the price point for each of the UK markets. Currently, this data only reflects JDTW 700ml and 1l. However, over time the list of brands covered will continue to grow and this document will be updated to reflect.

## Data Feed

### US Open Markets
**Data Provider:** Nielsen

For these markets, we are able to pull the data in from `EH_NARNielsen` enterprise hub within the `DP_NAR` database - which is the database warehousing the Nielsen data extract within our _data-lake infrastructure_. 

### US Control Markets
**Data Provider:** NABCA

For these markets, we are able to pull the data in from `EH_NABCA` enterprise hub within the `DP_NABCA` database - which is the database warehousing the Nielsen data extract within our _data-lake infrastructure_. 

### AU Total Market
**Data Provider:** Aztec

For these markets, a flat file was pulled from the Aztec system by the market team and sent directly to us via email. 

### UK Total Market
**Data Provider:** Nielsen

For these markets, a flat file was pulled from the Nielsen system by the market team and sent directly to us via email.
