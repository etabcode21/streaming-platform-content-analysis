import pandas as pd
import matplotlib.pyplot as plt


df = pd.read_csv("data/platform_movie_duration.csv")

print(df.head())

plt.figure(figsize=(10,6))

bars = plt.bar(
    df["platform"],
    df["avg_duration_minutes"]

)

plt.bar_label(bars, fmt="%.1f min", padding=4)

plt.title("Average Movie Duration: Disney+ vs Amazon Prime")
plt.xlabel("Streaming Platform")
plt.ylabel("Average Movie Duration (Minutes)")

plt.ylim(0, df["avg_duration_minutes"].max() * 1.2)

plt.tight_layout()


plt.savefig("charts/platform_movie_duration.png", dpi=300)

plt.show()
