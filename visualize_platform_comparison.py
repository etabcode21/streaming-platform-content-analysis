import pandas as pd
import matplotlib.pyplot as plt

# load comparison results
df = pd.read_csv("data/platform_content_types.csv")

print(df.head())

# rearrange data
pivot_df = df.pivot(
    index="platform",
    columns="type",
    values="percentage"
)
pivot_df = pivot_df.reindex(
    index=["Disney+", "Amazon Prime"],
    columns=["Movie", "TV Show"]
)

ax = pivot_df.plot(
    kind="bar",
    figsize=(10, 6),
    rot=0
)



for bars in ax.containers:
    ax.bar_label(bars, fmt="%.1f%%", padding=3)

plt.title("Movies vs TV Shows: Disney+ and Amazon Prime")
plt.xlabel("Streaming Platform")
plt.ylabel("Percentage of Catalog (%)")

plt.ylim(0, 100)
plt.legend(title="Content Type")
plt.tight_layout()



plt.savefig("charts/platform_content_types.png", dpi=300)

plt.show()


