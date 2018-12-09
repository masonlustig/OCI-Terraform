# Configure the Oracle Cloud Infrastructure provider with an API Key
#
#
variable "tenancy_ocid" { default = "ocid1.tenancy.oc1..aaaaaaaamyl7yxhouh4gafl5o6nqxszl5cyqdn3r23p2bzs2y6wzxkxrpgmq" }
variable "user_ocid" { default = "ocid1.user.oc1..aaaaaaaa3d2sbjzqx7tmpnbtk4iuddzh2l5inf6ekp4e2r57qlikr7tagfaq" }
variable "fingerprint" { default = " 0f:ff:cc:c7:f5:f9:39:fb:15:f8:ee:b8:d1:f2:51:14" }
variable "private_key_path" { default = "/var/tmp/lee_key/lee2_oci_api.pem" }
variable "compartment_ocid" { default = "ocid1.compartment.oc1..aaaaaaaaejqzgow57yn6niqzlkmibdeztueosnfxkp6uuit22wkzbgs7dtfq" }
variable "region" { default = "us-ashburn-1" }


# provider "oci" {
#   version          = ">= 3.0.0"
#   region           = "us-ashburn-1"
#   tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaqtyglek3dxjah6jw3j6lffdhw2slkhkymccy6zplw2cb52a3malq"
#   user_ocid        = "ocid1.user.oc1..aaaaaaaaxjrga3mtpmlafgp2qpai6htzdqtd6hup7ewcukogktlkueb7elkq"
#   fingerprint      = "0f:ff:cc:c7:f5:f9:39:fb:15:f8:ee:b8:d1:f2:51:14"
#   private_key_path = "/var/tmp/lee_key/lee2_oci_api.pem"
# }

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ads.availability_domains}"
}


/*
 * This example shows how to use the audit_configuration Resource to set the event retention period and list events with
 * the audit_events Data Source.
 */

resource "oci_audit_configuration" "audit_configuration" {
  compartment_id        = "${var.tenancy_ocid}"
  retention_period_days = "99"
}

data "oci_audit_configuration" "audit_configuration" {
  compartment_id = "${var.tenancy_ocid}"
}

output "retention_period_days" {
  value = "${data.oci_audit_configuration.audit_configuration.retention_period_days}"
}

data "oci_audit_events" "audit_events" {
  compartment_id = "${var.compartment_ocid}"

  # NOTE: These dates should be updated to applicable ranges of events within your tenancy.
  # CAUTION: Specifying wide date ranges may pull excessively large sets of event data from the Audit service.
  start_time = "${timeadd(timestamp(), "-1m")}"

  end_time = "${timestamp()}"
}

output "audit_events" {
  value = "${data.oci_audit_events.audit_events.audit_events}"
}



