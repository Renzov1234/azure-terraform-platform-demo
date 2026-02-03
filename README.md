# Serverless Expense API – Azure, Terraform & GitHub Actions

**Praxisprojekt:** Cloud, Infrastructure as Code und CI/CD in einem Setup

Rechts im Header: Azure | Terraform | GitHub (Icons/Logos)

---

## Kurzüberblick

### Projekt in 1 Satz

Eine serverlose Expense-API auf Azure. Die komplette Infrastruktur ist mit Terraform beschrieben und Deployments laufen über GitHub Actions. Das Ganze ist ein Portfolio-Projekt, um Azure, IaC und CI/CD Skills zu zeigen.

**Ziele**

*  Azure praktisch anwenden
*  Infrastruktur als Code (Terraform)
*  Automatisierte Deployments (GitHub Actions)
*  Günstig & realitätsnah

---

## Was kann die Anwendung?

### API-Endpunkte

*  **POST /api/expenses** – neü Ausgabe speichern
*  **GET /api/expenses** – Ausgaben abrufen

### Funktionalität

*  Speichert Datum, Kategorie, Beschreibung, Betrag
*  Läuft als Azure Function (HTTP Trigger, Consumption Plan)
*  Daten liegen in Table Storage oder Cosmos DB (Free Tier)

---

## Architektur

**Diagramm (einfach, mit Pfeilen und Textboxen)**

**User** → **Azure Function App**

Von der Function App gehen zwei Pfeile nach unten:

* → **Storage / DB**
* → **Application Insights (Logs & Monitoring)**

**Kurztext unter dem Diagramm**
Die API läuft als Azure Function im Consumption Plan. Daten werden in einem günstigen Azure-Speicher abgelegt. Monitoring übernimmt Application Insights.

---

## Tech-Stack

| Bereich    | Tech                                              |
| ---------- | ------------------------------------------------- |
| Cloud      | Azure                                             |
| Compute    | Azure Functions                                   |
| Storage    | Table Storage / Cosmos DB                         |
| Monitoring | Application Insights                              |
| IaC        | Terraform (Remote State, Module, Envs)            |
| CI/CD      | GitHub Actions (Plan/Apply, Build & Deploy)       |
| Code       | Node.js / TypeScript (oder was du wirklich nutzt) |

---

## CI/CD & Terraform

### So läuft Deploy & Infrastruktur

**Drei Unterboxen nebeneinander**

**Box 1: Terraform CI**

* **terraform-ci.yml**
* Läuft bei Pull Reqüsts
* Macht: fmt, validate, plan
* Zeigt änderungen an der Infrastruktur

**Box 2: Terraform Apply**

* **terraform-apply.yml**
* Manüll oder bei Merge auf main
* Nutzt GitHub Environments & Approval
* Deployt zum Beispiel nach prod

**Box 3: App Deploy**

* **app-deploy.yml**
* Baut & testet die Function App
* Deployt Code zur richtigen Function App (dev/prod)

Kleiner Satz darunter:
Damit ist der komplette Weg abgedeckt: Code → Plan → Review → Apply → Deploy.

---

## Kosten & Sicherheit

### Kosten 

* Functions im Consumption Plan → fast keine Kosten bei wenig Traffic
* Storage / DB auf Free/Low Tier
* Application Insights mit Sampling
* Budget/Alerts für Ressourcengruppe möglich

### Sicherheit 

* Deployments über Azure Service Principal
* Secrets nur in GitHub Secrets, nicht im Code
* Terraform Remote State im Azure Storage

---

## Was dieses Projekt zeigt

* Ich kann eine kleine, realistische Azure-Architektur eigenständig planen und umsetzen.
* Ich setze Infrastruktur konseqünt mit Terraform um (Remote State, Module, Environments).
* Ich baue CI/CD Pipelines mit GitHub Actions, inkl. Plan/Apply Logik und Environments.
* Ich denke an Kosten, Monitoring und Security, nicht nur daran, dass es irgendwie läuft.


**Portfolio-Projekt von Renzo** – basierend auf meinen Zertifizierungen AZ-900, GH-200 und Terraform Associate.
