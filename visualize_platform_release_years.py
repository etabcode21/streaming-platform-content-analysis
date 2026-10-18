import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/platform_release_years.csv")

print(df.head())

pivot_df = df.pivot(
    index="release_year",
    columns="platform",
    values="percentage"
)

pivot_df = pivot_df.fillna(0).sort_index()

plt.figure(figsize=(11, 6))

plt.plot(
    pivot_df.index,
    pivot_df["Disney+"],
    marker="o",
    label="Disney+"
)

plt.plot(
    pivot_df.index,
    pivot_df["Amazon Prime"],
    marker="o",
    label="Amazon Prime"
)

plt.title("Release Year Distribution: Disney+ vs Amazon Prime")
plt.xlabel("Original Release Year")
plt.ylabel("Percentage of 2010–2021 Titles (%)")

plt.xticks(pivot_df.index, rotation=45)
plt.grid(axis="y", alpha=0.3)
plt.legend()
plt.tight_layout()

plt.savefig("charts/platform_release_years.png", dpi=300)

plt.show()
