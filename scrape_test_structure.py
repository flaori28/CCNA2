
import requests
from bs4 import BeautifulSoup

url = "https://ccnareponses.com/ccna-2-examen-final-de-cours-srwe-v7-0-questions-reponses/"
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

try:
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Let's try to find the container of the questions. 
    # Usually in WordPress sites like this, it's in a specific div.
    potential_content = soup.find('div', class_='entry-content')
    
    if not potential_content:
        print("Could not find 'entry-content' div. Printing first 1000 chars of body...")
        print(soup.body.prettify()[:1000])
    else:
        # Print the first few logical blocks (paragraphs, lists) to understand structure
        print("Found entry-content. Printing structure of first few elements:")
        for element in list(potential_content.children)[:20]:
            if element.name:
                print(f"--- {element.name} ---")
                print(str(element)[:500]) # Truncate to avoid huge output

except Exception as e:
    print(f"Error: {e}")
