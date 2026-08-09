// ─────────────────────────────────────────────────────────────
// common.cds
// Reusable types, code lists, and shared type definitions for the
// Vacation & Traveller Management data model.
// Single source of truth for reusable artifacts referenced by schema.cds.
// ─────────────────────────────────────────────────────────────
namespace anubhav.claude;

using sap from '@sap/cds/common';

entity AddressTypes : sap.common.CodeList {
    key code : String(1) @title: '{i18n>Code}';
}

entity TravellerStatus : sap.common.CodeList {
    key code : String(1) @title: '{i18n>Code}';
}

entity Roles : sap.common.CodeList {
    key code : String(10) @title: '{i18n>Code}';
}

type AddressType : Association to AddressTypes;
type Status      : Association to TravellerStatus;
type Role        : Association to Roles;
