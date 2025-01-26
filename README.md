# 🧾 Electronic Invoicing Solution

Welcome to the **Electronic Invoicing Solution for Halltec Challenge solution for Factus API implementation.**, a Flutter-based application designed to integrate with the [Factus API](https://developers.factus.com.co/) for generating electronic invoices in Colombia. This basic Android app offers invoice management functionalities such as listing, viewing, and downloading invoices in PDF format. It also provides a feature to create, validate, and manage electronic invoices in compliance with DIAN regulations, including invoices with pre-defined products. This is a prototype and not intended for production environments.

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Project Structure](#project-structure)
5. [Features and Functionalities](#features-and-functionalities)
6. [Running the Application](#running-the-application)
7. [Dependencies](#dependencies)
8. [License](#license)
9. [Contact](#contact)

---

## 🖥️ Project Overview

The **Electronic Invoicing Solution** is a Flutter application that interacts with the Factus API for managing electronic invoices in Colombia. It provides tools to create, validate, and monitor invoices while ensuring compliance with local regulations.

---

## 🔧 Requirements

- **Flutter SDK**: Install the latest stable version from the [official Flutter website](https://flutter.dev/docs/get-started/install).
- **Valid Factus API credentials**.

---

## ⚙️ Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Marvin-Cerdas-Dev/facturacion.git
   cd facturacion
   ```
  
2. **Open the project and add the dependencies**:
   ```bash
   flutter pub add http
   flutter pub add shared_preferences
   flutter pub add sqflite
   flutter pub add qr_flutter
   flutter pub add path_provider
   flutter pub add open_file
   flutter pub add permission_handler
    ```

3. **Clone the repository**:
   ```bash
   flutter pub get
   ```

---

## 📁 Project Structure

The project is structured as follows:
   ```
   facturacion/ 
   ├── android/ # Native Android code 
   ├── ios/ # Native iOS code 
   ├── lib/ 
   │    ├── const/ # Application constants 
   │    ├── data/ # Data models and DTOs 
   │    │     ├── bill_data.dart 
   │    │     ├── bill_details.dart 
   │    │     ├── bill_request.dart 
   │    │     ├── bill.dart 
   │    │     ├── company.dart 
   │    │     ├── customer.dart 
   │    │     ├── item.dart 
   │    │     ├── legal_organization.dart 
   │    │     ├── measurement_units.dart 
   │    │     ├── municipality.dart 
   │    │     ├── numbering_range.dart 
   │    │     ├── numbering_rate.dart 
   │    │     ├── rate.dart 
   │    │     ├── tables.dart 
   │    │     ├── token.dart 
   │    │     ├── tributes.dart 
   │    │     └── withholding_tax.dart 
   │    ├── screens/ # UI screens 
   │    │     ├── add_products.dart 
   │    │     ├── bill_details_screen.dart 
   │    │     ├── create_bill_screen.dart  
   │    │     └── home_screen.dart 
   │    ├── services/ # API interaction and logic services 
   │    │     ├── auth_service.dart 
   │    │     ├── bill_service.dart 
   │    │     ├── list_item.dart 
   │    │     ├── measurement_unit_service.dart 
   │    │     ├── municipality_service.dart 
   │    │     ├── numb_range_service.dart 
   │    │     ├── storage_service.dart 
   │    │     └── tribute_service.dart 
   │    ├── widget/ # Reusable widgets 
   │    │     ├── bill_details_widget.dart 
   │    │     ├── bill_list_widget.dart 
   │    │     └── test.dart 
   │    └── main.dart # Application entry point 
   ├── pubspec.yaml # Project dependencies and metadata 
   └── README.md # Documentation
   ```

---

## 🌐 Features and Functionalities

The application provides the following key features:

   Invoice Management:
        Create, validate, and send electronic invoices via the Factus API.
        Download invoices in PDF format for easy access and sharing.

   User-Friendly Interface:
        Simplified navigation for an enhanced user experience.
        QR code generation for quick and easy invoice confirmation in the regulatory organization (DIAN).

---

## 🚀 Running the Application

To run the application, ensure you have a physical device or emulator connected. Then execute the following command:
   ```bash
   flutter run
   ```
---

## 📜 License

This project is licensed under the MIT License. Feel free to use, modify, and distribute it under the terms of the license.

---

## 🤝 Contact

Developed by Marvin Cerdas. For questions, feedback, or support, feel free to reach out:

   Marvin Cerdas - [GitHub Profile](https://github.com/Marvin-Cerdas-Dev)
