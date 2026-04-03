import time
from pathlib import Path

from neo4j import GraphDatabase
from neo4j.exceptions import ServiceUnavailable


NEO4J_URI = "bolt://127.0.0.1:7687"
NEO4J_USERNAME = "neo4j"
NEO4J_PASSWORD = "fraudproto123"

BASE_DIR = Path(__file__).resolve().parent.parent
SCHEMA_FILE = BASE_DIR / "cypher" / "schema.cypher"
DATA_FILE = BASE_DIR / "cypher" / "sample_data.cypher"
DETECTION_FILE = BASE_DIR / "cypher" / "detection_queries.cypher"


def split_queries(file_path: Path) -> list[str]:
    content = file_path.read_text(encoding="utf-8")
    return [query.strip() for query in content.split(";") if query.strip()]


def run_script(session, file_path: Path) -> None:
    for query in split_queries(file_path):
        session.run(query).consume()


def print_result(title: str, records) -> None:
    print(f"\n=== {title} ===")
    rows = list(records)
    if not rows:
        print("No suspicious patterns found.")
        return

    for row in rows:
        print(dict(row))


def wait_for_neo4j(driver, retries: int = 12, delay_seconds: int = 5) -> None:
    for attempt in range(1, retries + 1):
        try:
            driver.verify_connectivity()
            return
        except ServiceUnavailable:
            if attempt == retries:
                raise
            print(f"Neo4j not ready yet, retrying ({attempt}/{retries})...")
            time.sleep(delay_seconds)


def main() -> None:
    driver = GraphDatabase.driver(
        NEO4J_URI,
        auth=(NEO4J_USERNAME, NEO4J_PASSWORD),
    )

    wait_for_neo4j(driver)

    with driver.session() as session:
        print("Applying schema...")
        run_script(session, SCHEMA_FILE)

        print("Loading sample data...")
        run_script(session, DATA_FILE)

        detection_queries = split_queries(DETECTION_FILE)
        detection_titles = [
            "Users sharing devices and cards",
            "Indirectly linked users within four hops",
            "Cards reused across multiple users",
            "Transactions connected through shared infrastructure",
        ]

        for title, query in zip(detection_titles, detection_queries, strict=True):
            result = session.run(query)
            print_result(title, result)

    driver.close()


if __name__ == "__main__":
    main()
