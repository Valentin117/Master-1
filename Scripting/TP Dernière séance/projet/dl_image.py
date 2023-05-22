from pandas import read_csv
import requests
df = read_csv("dataset_client.csv")
images = df["image"]
for idx, image in enumerate(images[:50]):
    url_image = eval(image)[0]
    image = requests.get(url_image).content
    with open(f"site/static/{idx}.png", "wb") as file_image:
        file_image.write(image)