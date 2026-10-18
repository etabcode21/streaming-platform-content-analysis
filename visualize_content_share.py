import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/yearly_content_share.csv")

print(df.head())

# Rearrange data that moveis and tv shows are columns
pivot_df = df.pivot(
    index="release_year",
    columns="type",
    values="percentage"
)

# Replace N/A content to 0s
pivot_df = pivot_df.fillna(0)
pivot_df = pivot_df.reindex(columns=["Movie", "TV Show"], fill_value=0)
pivot_df = pivot_df.sort_index()

print(pivot_df.head())


ax = pivot_df.plot(
    kind="bar",
    stacked=True,
    figsize=(12, 6)
)

plt.title("Disney+ Movies vs TV Shows by Release Year")
plt.xlabel("Release Year")
plt.ylabel("Percentage of Titles (%)")


plt.ylim(0, 100)


plt.xticks(rotation=45)

plt.legend(title="Content Type")
plt.tight_layout()


plt.savefig("charts/yearly_content_share.png", dpi=300)

plt.show()
