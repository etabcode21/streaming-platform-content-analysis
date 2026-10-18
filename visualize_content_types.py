import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/content_types.csv")

print(df.head())


plt.figure(figsize=(8, 6))

plt.pie(
    df["total_count"],
    labels=df["type"],
    autopct="%1.1f%%",
    startangle=90
)

plt.title("Disney+ Movies vs Tv Shows")
plt.axis("equal")
plt.tight_layout()
plt.savefig("charts/content_types.png", dpi=300)
plt.show()