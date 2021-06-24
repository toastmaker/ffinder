import requests
import bs4 as bs
#URL='http://ibas.iasf-milano.inaf.it/IBAS_Results.html'
#page = requests.get(URL)
fn = "../IBAS_Results-corrected.html"

with open(fn, 'r') as f:

	contents = f.read()
	
soup = bs.BeautifulSoup(contents, 'html.parser')
for row in soup.select("tbody tr"):
	row_text = [x.text.replace("\n","").strip() for x in row.find_all("td")]
	print("|".join(row_text))
