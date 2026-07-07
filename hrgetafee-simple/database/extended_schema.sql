-- HRGetafe Extended Database Schema
-- This file ONLY ADDS new tables - NO modifications to existing tables
-- Run this AFTER setup.sql

-- Create Deduction Types Table
CREATE TABLE IF NOT EXISTS deduction_types (
  deduction_id INT PRIMARY KEY AUTO_INCREMENT,
  deduction_name VARCHAR(50) NOT NULL,
  deduction_code VARCHAR(10) UNIQUE NOT NULL,
  description TEXT,
  is_mandatory BOOLEAN DEFAULT 1,
  calculation_type ENUM('fixed', 'percentage') DEFAULT 'fixed',
  default_rate DECIMAL(10, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Employee Deductions Table
CREATE TABLE IF NOT EXISTS employee_deductions (
  emp_deduction_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_id INT NOT NULL,
  deduction_id INT NOT NULL,
  amount DECIMAL(10, 2),
  effective_date DATE,
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  FOREIGN KEY (deduction_id) REFERENCES deduction_types(deduction_id)
);

-- Create Payroll Details Table (Breakdown of deductions)
CREATE TABLE IF NOT EXISTS payroll_details (
  payroll_detail_id INT PRIMARY KEY AUTO_INCREMENT,
  payroll_id INT NOT NULL,
  detail_type ENUM('earning', 'deduction') NOT NULL,
  detail_name VARCHAR(100) NOT NULL,
  amount DECIMAL(10, 2),
  quantity INT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (payroll_id) REFERENCES payroll(payroll_id)
);

-- Create Leave Compensation Table (AMS-based)
CREATE TABLE IF NOT EXISTS leave_compensation (
  compensation_id INT PRIMARY KEY AUTO_INCREMENT,
  ams_value DECIMAL(5, 1),
  leave_earned_days DECIMAL(5, 2),
  leave_earned_amount DECIMAL(10, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(ams_value)
);

-- Create Hours to Fractions Conversion Table
CREATE TABLE IF NOT EXISTS hours_fraction_conversion (
  conversion_id INT PRIMARY KEY AUTO_INCREMENT,
  hours INT,
  minutes INT,
  fraction_of_day DECIMAL(5, 4),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(hours, minutes)
);

-- Create Leave Type Categories Table
CREATE TABLE IF NOT EXISTS leave_type_categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  leave_type_id INT NOT NULL,
  category_name VARCHAR(50) NOT NULL,
  is_paid BOOLEAN DEFAULT 1,
  with_pay_percentage DECIMAL(5, 2) DEFAULT 100.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id)
);

-- =====================================================
-- INSERT DEFAULT DEDUCTION TYPES
-- =====================================================
INSERT INTO deduction_types (deduction_name, deduction_code, description, is_mandatory, calculation_type, default_rate) VALUES
('SSS', 'SSS', 'Social Security System', 1, 'percentage', 3.63),
('PhilHealth', 'PH', 'PhilHealth Insurance', 1, 'percentage', 2.75),
('Pag-IBIG', 'PAGIBIG', 'Home Development Mutual Fund', 1, 'percentage', 2.00),
('BIR - Income Tax', 'BIR', 'Bureau of Internal Revenue Tax', 1, 'percentage', 0.00),
('CPF', 'CPF', 'Consolidated Police Fund', 1, 'fixed', 971.75),
('CBIF', 'CBIF', 'Comprehensive Benefit Insurance Fund', 1, 'fixed', 0.00),
('MPL', 'MPL', 'Magna Carta for Public Employees Levy', 1, 'fixed', 0.00),
('Absence Deduction', 'ABSENCE', 'Deduction for absences', 0, 'fixed', 500.00),
('Late Deduction', 'LATE', 'Deduction for late arrivals', 0, 'fixed', 100.00);

-- =====================================================
-- INSERT HOURS TO FRACTIONS CONVERSION TABLE
-- Based on 8-hour work day
-- =====================================================
INSERT INTO hours_fraction_conversion (hours, minutes, fraction_of_day) VALUES
(1, 0, 0.1250), (2, 0, 0.2500), (3, 0, 0.3750), (4, 0, 0.5000),
(5, 0, 0.6250), (6, 0, 0.7500), (7, 0, 0.8750), (8, 0, 1.0000),
(1, 15, 0.1313), (1, 30, 0.1375), (1, 45, 0.1438),
(2, 15, 0.2438), (2, 30, 0.3125), (2, 45, 0.3438),
(3, 15, 0.4063), (3, 30, 0.4375), (3, 45, 0.4688),
(4, 15, 0.5313), (4, 30, 0.5625), (4, 45, 0.5938),
(5, 15, 0.6563), (5, 30, 0.6875), (5, 45, 0.7188),
(6, 15, 0.7813), (6, 30, 0.8125), (6, 45, 0.8438),
(7, 15, 0.9063), (7, 30, 0.9375), (7, 45, 0.9688);

-- =====================================================
-- INSERT LEAVE COMPENSATION TABLE
-- Based on AMS (Anniversary of Month Service) for Getafe LGU
-- =====================================================
INSERT INTO leave_compensation (ams_value, leave_earned_days, leave_earned_amount) VALUES
(0.5, 1.229, 1.229),
(1.0, 1.200, 1.200),
(1.5, 1.188, 1.188),
(2.0, 1.167, 1.167),
(2.5, 1.146, 1.146),
(3.0, 1.125, 1.125),
(3.5, 1.104, 1.104),
(4.0, 1.083, 1.083),
(4.5, 1.063, 1.063),
(5.0, 1.042, 1.042),
(5.5, 1.021, 1.021),
(6.0, 1.000, 1.000),
(6.5, 0.979, 0.979),
(7.0, 0.958, 0.958),
(7.5, 0.938, 0.938),
(8.0, 0.917, 0.917),
(8.5, 0.896, 0.896),
(9.0, 0.875, 0.875),
(9.5, 0.854, 0.854),
(10.0, 0.833, 0.833),
(10.5, 0.813, 0.813),
(11.0, 0.792, 0.792),
(11.5, 0.771, 0.771),
(12.0, 0.750, 0.750),
(12.5, 0.729, 0.729),
(13.0, 0.708, 0.708),
(13.5, 0.688, 0.688),
(14.0, 0.667, 0.667),
(14.5, 0.646, 0.646),
(15.0, 0.625, 0.625),
(15.5, 0.604, 0.604),
(16.0, 0.583, 0.583),
(16.5, 0.562, 0.562),
(17.0, 0.542, 0.542),
(17.5, 0.521, 0.521),
(18.0, 0.500, 0.500),
(18.5, 0.479, 0.479),
(19.0, 0.458, 0.458),
(19.5, 0.437, 0.437),
(20.0, 0.417, 0.417);

-- =====================================================
-- UPDATE LEAVE TYPES WITH CATEGORY INFO
-- =====================================================
INSERT INTO leave_type_categories (leave_type_id, category_name, is_paid, with_pay_percentage) VALUES
(1, 'Vacation Leave With Pay', 1, 100.00),
(2, 'Sick Leave', 1, 100.00),
(3, 'Emergency Leave', 1, 100.00),
(4, 'Study Leave', 1, 100.00);
