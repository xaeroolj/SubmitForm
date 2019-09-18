//
//  VisitorModel.swift
//  SubmitForm
//
//  Created by Roman Trekhlebov on 17/09/2019.
//  Copyright © 2019 Roman Trekhlebov. All rights reserved.
//

import Foundation

enum VisitorType: String {
    case parent = "Parent / PADRE"
    case provider = "Provider / PROVEEDOR"
}

enum VisitReason: String, CaseIterable {
    case dropOff = "Drop off document(s) / ENTREGAR DOCUMENTO(S)"
    case pickUp = "Pick up document(s) / RECOGER DOCUMENTO(S)"
    case specialistApointment = "I have an appointment with CalWORKs Specialists / TENGO UNA CITA"
    case reaserchApointment = "I have an appointment with R&R Specialists"
    case referalService = "Resource & Referral Services"
    case diaperBox = "I am here to pick up diaper box" // No Options
    case noReason = "I do not have any appointment" // Share Reason
    
}
enum DropOffOptions: String, CaseIterable {
    case newCLient = "New Client Enrollment Packet / Formas de inscripción de nuevo ingreso"
    case chillSertificate = "Child Care Certificate(s) / Certificado de Contrato"
    case adressChange = "Change of Address / Cambio de Direccion"
    case providerChange = "Change of Provider / Cambio de Proveedor"
    case reCertification = "Re-certification Form / Formas de Recertificación"
    case VOE = "VOE / Verificación de Empleo (VOE)"
    case payStubs = "One to Three Months of Most Current Pay Stubs / Uno o Tres meses de talones de cheque"
    case schoolRegistration = "School Registration / Registración de escuela"
    case educationPlan = "Educational Plan / Plan Educacional"
    case semesterGrade = "School Quarter or Semester Grade / Calificaciones del Trimestre o Semestre pasado"
    case newProviderPacket = "New Provider Enrollment Packet"
    case providerTrustPacket = "Provider TrustLine Packet"
    case familyFeeReceipt = "Family Fee Receipt"
}
enum PickUpOptions: String, CaseIterable{
    
    case newCLient = "New Client Enrollment Packet / Formas de inscripción de nuevo ingreso"
    case chillSertificate = "Child Care Certificate(s) / Certificado de Contrato"
    case attendanceSheet = "Attendance Sheets / Forma de Asistencia (Timesheets)"
    case trustLinePacket = "TrustLine Packet for Exempt Provider"
    case adressChange = "Change of Address / Cambio de Direccion"
    case providerChange = "Change of Provider / Cambio de Proveedor"
    case reCertification = "Re-certification Form / Formas de Recertificación"
    case VOE = "VOE / Verificación de Empleo (VOE)"
    case selfEmployedVOE = "Self Employed VOE / Verificación de trabajadores por cuenta propia"
    case selfEmployedIncome = "Self Employed Income Statement / Estado de ingreso de trabajo por cuenta propia"
    case newProviderPacket = "New Provider Enrollment Packet"
    case providerTrustPacket = "Provider TrustLine Packet"
    case diaperBox = "Diaper Box"
    case other = "Other (Please type in the box below) / Otro (porfavor especifique en la caja de abajo)"
}

enum SpecialistApointmentOptions: String, CaseIterable{
    case Aireen
    case Carolina
    case Charles
    case Gabriel
    case Juliet
    case Maria
    case Sally
    case Shannon
    case rrS = "Resource & Referral Services"
}

enum ReaserchApointmentOptions: String, CaseIterable {
    case Alison
    case Arlene
    case Ariana
    case Cynthia
    case Darlyn
    case Erica
    case Iris
    case Sharyn
}

enum ReferalServiceHelpOptions: String, CaseIterable  {
    case licensedProvider = "I wont to know how to become a licensed provider"
    case listOfProviders = "I need a list of providers in Souther Alameda County"
    case needReferals = "I need referals to other subsidies who may be able to help me to pay for child care services"
}

