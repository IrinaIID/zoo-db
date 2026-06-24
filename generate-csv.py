import csv
import random
from datetime import datetime, timedelta

random.seed(42)

def write_csv(filename, header, rows):
    with open(filename, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(rows)

def rand_date(start_days_ago=365):
    start = datetime.now() - timedelta(days=start_days_ago)
    return (start + timedelta(days=random.randint(0, start_days_ago))).strftime("%Y-%m-%d")

# ---------------- SPECIES ----------------
species = [
    ("Lion","Savanna","Carnivore"),
    ("Tiger","Forest","Carnivore"),
    ("Elephant","Grassland","Herbivore"),
    ("Giraffe","Savanna","Herbivore"),
    ("Zebra","Savanna","Herbivore"),
    ("Penguin","Arctic","Carnivore"),
    ("Monkey","Jungle","Omnivore"),
    ("Bear","Forest","Omnivore"),
    ("Wolf","Forest","Carnivore"),
    ("Kangaroo","Grassland","Herbivore"),
]

write_csv("species.csv", ["SpeciesName","HabitatType","DietType"], species)

# ---------------- ENCLOSURES ----------------
enclosures = [
    ("Big Cats Zone","A",10),
    ("Elephant Area","B",8),
    ("Savanna Zone","C",15),
    ("Bird House","D",30),
    ("Reptile Center","E",20),
    ("Monkey Island","F",25),
    ("Arctic Habitat","G",12),
    ("Forest Habitat","H",18),
]

write_csv("enclosures.csv", ["EnclosureName","Zone","Capacity"], enclosures)

# ---------------- EMPLOYEES ----------------
first_names = ["John","Emma","Michael","Sophia","Daniel","Olivia","James","Liam","Mia","Noah","Ava","Ethan"]
last_names = ["Smith","Johnson","Brown","Davis","Wilson","Taylor","Anderson","Thomas","Moore","Jackson","Martin","Lee"]

employees = []
for i in range(12):
    employees.append((
        first_names[i],
        last_names[i],
        random.choice(["Zookeeper","Veterinarian","Manager"]),
        rand_date(2000)
    ))

write_csv("employees.csv", ["FirstName","LastName","Position","HireDate"], employees)

# ---------------- ANIMALS ----------------
animal_names = [
    "Simba","Nala","ShereKhan","Dumbo","Melman","Marty","Skipper","Kowalski",
    "Gloria","KingJulien","Baloo","Akela","Shenzi","Banzai","Rafiki",
    "Bagheera","Mowgli","Bambi","Stitch","Bolt","Rocky","Apollo","Zeus",
    "Athena","Hera","Thor","Loki","Freya","Odin","Nova"
]

animals = []
for i in range(30):
    sp = random.choice(species)[0]
    enc = random.choice(enclosures)[0]
    animals.append((
        animal_names[i],
        rand_date(3650),
        random.choice(["M","F"]),
        sp,
        enc
    ))

write_csv("animals.csv", ["AnimalName","BirthDate","Gender","SpeciesName","EnclosureName"], animals)

# ---------------- VISITORS ----------------
cities = ["Vilnius","Kaunas","Klaipeda","Siauliai","Panevezys","Alytus","Jonava"]

visitors = []
for i in range(100):
    visitors.append((
        f"VIS{i:03d}",
        random.choice(["John","Emma","Mark","Laura","Tom","Anna","Paul","Kate","Luke","Marta"]),
        random.choice(["Smith","Johnson","Brown","Davis","Wilson"]),
        random.choice(cities),
        random.choice(["Registered","Anonymous"])
    ))

write_csv("visitors.csv",
          ["VisitorCode","FirstName","LastName","City","VisitorType"],
          visitors)

# ---------------- TICKET TYPES ----------------
ticket_types = [
    ("Adult",20),
    ("Child",10),
    ("Student",15),
    ("Family",50)
]

write_csv("ticket_types.csv", ["TicketType","Price"], ticket_types)

# ---------------- SALES ----------------
ticket_sales = []
for _ in range(300):
    v = random.choice(visitors)
    t = random.choice(ticket_types)
    ticket_sales.append((
        v[0],
        t[0],
        rand_date(365),
        random.randint(1,3)
    ))

write_csv("ticket_sales.csv",
          ["VisitorCode","TicketType","SaleDate","Quantity"],
          ticket_sales)

# ---------------- FEEDINGS ----------------
feedings = []
for _ in range(350):
    a = random.choice(animals)
    e = random.choice(employees)
    feedings.append((
        a[0],
        e[0],
        e[1],
        rand_date(365),
        round(random.uniform(1,50),2)
    ))

write_csv("feedings.csv",
          ["AnimalName","EmployeeFirstName","EmployeeLastName","FeedingDate","FoodAmountKg"],
          feedings)

# ---------------- VET VISITS ----------------
vet_employees = [e for e in employees if e[2] == "Veterinarian"] or employees

vet_visits = []
for _ in range(50):
    a = random.choice(animals)
    e = random.choice(vet_employees)
    vet_visits.append((
        a[0],
        e[0],
        e[1],
        rand_date(365),
        random.choice(["Healthy","Injury","Checkup","Sick","Recovery"])
    ))

write_csv("vet_visits.csv",
          ["AnimalName","VetFirstName","VetLastName","VisitDate","Diagnosis"],
          vet_visits)

print("All CSV files created!")


from google.colab import files

files.download("species.csv")
files.download("enclosures.csv")
files.download("employees.csv")
files.download("animals.csv")
files.download("visitors.csv")
files.download("ticket_types.csv")
files.download("ticket_sales.csv")
files.download("feedings.csv")
files.download("vet_visits.csv")