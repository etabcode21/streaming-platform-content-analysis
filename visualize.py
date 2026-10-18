import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/top_genres.csv")

print(df.head())

plt.figure(figsize=(10, 6))

plt.barh(df["genre"], df["total_count"])

plt.title("Top 10 Genres on Disney+")
plt.xlabel("Nubmer of Titles")
plt.ylabel("Genre")

plt.gca().invert_yaxis()

plt.tight_layout()


plt.savefig("charts/top_genres.png", dpi=300)

plt.show()
