import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/top_countries.csv")

print(df.head())

plt.figure(figsize=(10, 6))

bars = plt.barh(df["new_country"], df["total_content"])

plt.bar_label(bars, padding=3)

plt.title("Top 10 Countries with the Most Disney+ Content")
plt.xlabel("Number of Titles")
plt.ylabel("Country")
plt.gca().invert_yaxis()

plt.xlim(0, df["total_content"].max() * 1.15)

plt.tight_layout()
plt.savefig("charts/top_countries.png", dpi=300)
plt.show()