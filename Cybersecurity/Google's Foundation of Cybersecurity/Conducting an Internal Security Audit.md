# Scenario (fiction)
Botium Toys is a small U.S. business that develops and sells toys. The business has a single physical location, which serves as their main office, a storefront, and warehouse for their products. However, Botium Toy’s online presence has grown, attracting customers in the U.S. and abroad. As a result, their information technology (IT) department is under increasing pressure to support their online market worldwide. 

The manager of the IT department has decided that an internal IT audit needs to be conducted. She's worried about maintaining compliance and business operations as the company grows without a clear plan. She believes an internal audit can help better secure the company’s infrastructure and help them identify and mitigate potential risks, threats, or vulnerabilities to critical assets. The manager is also interested in ensuring that they comply with regulations related to internally processing and accepting online payments and conducting business in the European Union (E.U.).   

The IT manager starts by implementing the National Institute of Standards and Technology Cybersecurity Framework (NIST CSF), establishing an audit scope and goals, listing assets currently managed by the IT department, and completing a risk assessment. The goal of the audit is to provide an overview of the risks and/or fines that the company might experience due to the current state of their security posture.

Your task is to review the IT manager’s scope, goals, and risk assessment report. Then, perform an internal audit by completing a controls and compliance checklist. 

# Scope, Goals, and Risk Assessment Report
## Scope and Goals of the audit
### Scope
Entire security program in the company, including:
* employee equipment and devices,
* internal network, and
* systems.
### Goals
[] Assess assets
[] Complete the controls and compliance checklist

## Current Assets
* On-premises equipments (business needs)
* Employee equipment:
    * end-user devices (desktops/laptops, smartphones)
    * remote workstations
    * headsets
    * cables
    * keyboards
    * mice
    * docking stations
    * surveillance cameras
* Storefront products (offline & online)
* Management of systems, software, and services:
    * accounting
    * telecommunication
    * database
    * security 
    * e-commerce
    * inventory management
* Internet access
* Internal network
* Data retention and storage
* Legacy system maintenance

## Risk Assessment
### Risk Description
* Inadequate management of assets
* Lack of proper controls in place
* Not fully compliant with the US and international regulations and standards

### Control best practices
1. Identify current available assets -> managable
2. Classify each available assets on a scale of low, medium, or high -> risk management

### Risk score
__8/10__: Lack of controls and adherence to compliance best practice

### Additional comments
* All staff members have equally high access to internal data
* Lack of encryption regarding paument
* Access controls and least privilege is not set
* Availability is ensured by IT dept.
* Firewall is set
* AV is set
* IDS is NOT set
* Recovery plan is NOT set
* Policy, procedure, and process are in place in case of data breach
* Centralized password management is NOT set
* Physical locks at the stores are set
* CCTVs are set
* Fire detections are set

# Controls and Compliance Checklist
## Controls assessment
- [ ] Least Privilege
- [ ] Disaster recovery plans
- [x] Password policies
- [ ] Separation of duties
- [x] Firewall
- [ ] Intrusion Detection System (IDS)
- [ ] Backups
- [x] Antivirus software
- [ ] Manual monitoring, maintenance, and intervention for legacy ssystem
- [ ] Encryption
- [ ] Password management system
- [x] Locks (offices, storefront, warehouse)
- [x] CCTVs
- [x] Fire detection/prevention (fire alarm, sprinkler system, etc)

## Compliance assessment
### Payment Card Industry Data Security Standard (PCI DSS)
- [ ] Only authorized users have access to customer's credit card information.
- [ ] Credit card information is stored, accepted, processed and transmitted internally, in a secure environment
- [ ] Implement data encryption procedures to better secure credit card transaction touchpoints and data
- [ ] Adopt secure password management policies
### GEneral Data Protection Regulation (GDPR)
- [x] EU Customers' data is kept private/secured
- [x] There s a plan in place to notify EU customers within 72 hours if their data is compromised
- [ ] Ensure data is properly classified and inventoried
- [x] Enforced privacy policies, procedures, and processes, to properly document and maintain data
### System and Organization Controls (SOPC type 1, SOC type 2)
- [ ] User access policies are established
- [ ] Sensitive data (PII/SPII) is confidential/private
- [x] Data integrity ensures the data is consistent, complete, accurate, and has been validated
- [ ] Data is available to individuals authorized to access it