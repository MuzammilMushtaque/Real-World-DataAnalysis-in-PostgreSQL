# ForestQuery: Global Deforestation Analysis (1990-2016) using SQL

## Overview

ForestQuery is dedicated to addressing global deforestation issues and spreading awareness about the environmental impact of this critical problem. This project focuses on leveraging SQL for effective data handling and analysis. The data, sourced from the World Bank, comprises information on forest area, total land area, countries, and regions spanning the years 1990 to 2016.

## Key Objectives

1. **Mission:** Combat deforestation globally and raise awareness about its environmental consequences.

2. **Data Source:** World Bank data, including forest area, total land area, countries, and regions.

3. **Database Structure:**
   - Three main tables: Forest_area, Land_area, and Regions.
   - Primary key options: Country_name or country_code, with a total of 219 countries categorized into 8 regions.

## Importance of PostgreSQL

The ForestQuery data analysis team has chosen PostgreSQL as the preferred database management system for this project. Here's why PostgreSQL plays a crucial role:

### 1. **Robustness and Performance:**
   - PostgreSQL is known for its reliability and performance, handling large datasets efficiently.
   - Well-suited for complex queries and aggregations required in deforestation analysis.

### 2. **Data Integrity:**
   - Ensures data integrity through the enforcement of constraints and relationships between tables.
   - Supports transactions, guaranteeing the accuracy of data modifications.

### 3. **Advanced SQL Features:**
   - Offers advanced SQL features, enabling complex queries and subqueries for in-depth data exploration.
   - Supports window functions, facilitating time-series analysis on the dataset.

### 4. **Extensibility:**
   - Provides extensibility through custom functions, types, and operators, allowing tailored solutions for specific analysis requirements.

### 5. **Community Support:**
   - Boasts an active and supportive community that contributes to the ongoing development and improvement of PostgreSQL.

## Database Tables

1. **Forest_area:**
   - Fields: Country_name, Country_code, Year, Forest_area.

2. **Land_area:**
   - Fields: Country_name, Country_code, Year, Total_land_area.

3. **Regions:**
   - Fields: Country_name, Region.

## Project Scope

The ForestQuery team will use PostgreSQL's capabilities to analyze deforestation trends, assess the impact on regions, and formulate insights to guide future conservation efforts.

Feel free to explore the SQL queries and analysis performed in this project. Your contributions and feedback are valuable in advancing ForestQuery's mission. Together, let's combat global deforestation and work towards a sustainable future.