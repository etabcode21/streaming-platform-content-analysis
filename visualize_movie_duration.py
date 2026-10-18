
import pandas as pd
import matplotlib.pyplot as plt


df = pd.read_csv("data/average_movie_duration.csv")

print(df.head())


df = df.sort_values("release_year")

plt.figure(figsize=(11, 6))


plt.plot(
    df["release_year"],
    df["average_duration_minutes"],
    marker="o",
    linewidth=2
)

plt.title("Average Disney+ Movie Duration by Release Year")
plt.xlabel("Release Year")
plt.ylabel("Average Duration (Minutes)")


plt.grid(axis="y", alpha=0.3)

plt.tight_layout()


plt.savefig("charts/average_movie_duration.png", dpi=300)

plt.show()
