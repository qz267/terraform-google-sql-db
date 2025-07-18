/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "name" {
  type        = string
  description = "The name of the Cloud SQL instance"
}

variable "master_instance_name" {
  type        = string
  description = "Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover failover replica instance as master instance"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The type of the instance. The supported values are SQL_INSTANCE_TYPE_UNSPECIFIED, CLOUD_SQL_INSTANCE, ON_PREMISES_INSTANCE and READ_REPLICA_INSTANCE. Set to READ_REPLICA_INSTANCE when primary_instance_name is provided"
  default     = "CLOUD_SQL_INSTANCE"
}

variable "random_instance_name" {
  type        = bool
  description = "Sets random suffix at the end of the Cloud SQL resource name"
  default     = false
}

variable "maintenance_version" {
  description = "The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored"
  type        = string
  default     = null
}

// required
variable "database_version" {
  description = "The database version to use: SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, or SQLSERVER_2017_WEB"
  type        = string
  default     = "SQLSERVER_2017_STANDARD"
}

// required
variable "region" {
  type        = string
  description = "The region of the Cloud SQL resources"
  default     = "us-central1"
}

variable "tier" {
  description = "The tier for the Cloud SQL instance."
  type        = string
  default     = "db-custom-2-3840"
}

variable "edition" {
  description = "The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS."
  type        = string
  default     = null
}

variable "zone" {
  type        = string
  description = "The zone for the Cloud SQL instance."
  default     = null
}

variable "secondary_zone" {
  type        = string
  description = "The preferred zone for the read replica instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = null
}

variable "follow_gae_application" {
  type        = string
  description = "A Google App Engine application whose zone to remain in. Must be in the same region as this instance."
  default     = null
}

variable "activation_policy" {
  description = "The activation policy for the Cloud SQL instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "availability_type" {
  description = "The availability type for the Cloud SQL instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = "ZONAL"
}

variable "deletion_protection_enabled" {
  description = "Enables protection of an instance from accidental deletion protection across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size."
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased."
  type        = number
  default     = 0
}

variable "disk_size" {
  description = "The disk size for the Cloud SQL instance."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the Cloud SQL instance."
  type        = string
  default     = "PD_SSD"
}

variable "pricing_plan" {
  description = "The pricing plan for the Cloud SQL instance."
  type        = string
  default     = "PER_USE"
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the Cloud SQL maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the Cloud SQL maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the Cloud SQL maintenance.Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "deny_maintenance_period" {
  description = "The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/sqlserver/maintenance)"
  type = list(object({
    end_date   = string
    start_date = string
    time       = string
  }))
  default = []
}

variable "database_flags" {
  description = "The database flags for the Cloud SQL. See [more details](https://cloud.google.com/sql/docs/sqlserver/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "data_cache_enabled" {
  description = "Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE_PLUS tier and supported database_versions"
  type        = bool
  default     = false
}

variable "active_directory_config" {
  description = "Active domain that the SQL instance will join."
  type        = map(string)
  default     = {}
}

variable "sql_server_audit_config" {
  description = "SQL server audit config settings."
  type        = map(string)
  default     = {}
}

variable "user_labels" {
  description = "The key/value labels for the Cloud SQL instances."
  type        = map(string)
  default     = {}
}

variable "ip_configuration" {
  description = "The ip configuration for the Cloud SQL instances."
  type = object({
    authorized_networks = optional(list(map(string)), [])
    ipv4_enabled        = optional(bool)
    private_network     = optional(string)
    allocated_ip_range  = optional(string)
    ssl_mode            = optional(string)
  })
  default = {
    authorized_networks = []
    ipv4_enabled        = true
    private_network     = null
    allocated_ip_range  = null
    ssl_mode            = null
  }
}

variable "backup_configuration" {
  description = "The database backup configuration."
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    point_in_time_recovery_enabled = bool
    start_time                     = string
    transaction_log_retention_days = string
    retained_backups               = number
    retention_unit                 = string
  })
  default = {
    binary_log_enabled             = null
    enabled                        = false
    point_in_time_recovery_enabled = null
    start_time                     = null
    transaction_log_retention_days = null
    retained_backups               = null
    retention_unit                 = null
  }
}

variable "db_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "default"
}

variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'en_US.UTF8'"
  type        = string
  default     = ""
}

variable "additional_databases" {
  description = "A list of databases to be created in your cluster"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable "user_name" {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}

variable "additional_users" {
  description = "A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set."
  type = list(object({
    name            = string
    password        = string
    random_password = bool
  }))
  default = []
  validation {
    condition     = length([for user in var.additional_users : false if user.random_password == true && (user.password != null && user.password != "")]) == 0
    error_message = "You cannot set both password and random_password, choose one of them."
  }
}

variable "root_password" {
  description = "MSSERVER password for the root user. If not set, a random one will be generated and available in the root_password output variable."
  type        = string
  default     = ""
}

variable "create_timeout" {
  description = "The optional timeout that is applied to limit long database creates."
  type        = string
  default     = "30m"
}

variable "update_timeout" {
  description = "The optional timeout that is applied to limit long database updates."
  type        = string
  default     = "30m"
}

variable "delete_timeout" {
  description = "The optional timeout that is applied to limit long database deletes."
  type        = string
  default     = "30m"
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "connector_enforcement" {
  description = "Enforce that clients use the connector library"
  type        = bool
  default     = false
}

variable "time_zone" {
  description = "The time zone for Cloud SQL instance."
  type        = string
  default     = null
}

variable "enable_default_db" {
  description = "Enable or disable the creation of the default database"
  type        = bool
  default     = true
}

variable "enable_default_user" {
  description = "Enable or disable the creation of the default user"
  type        = bool
  default     = true
}

variable "enable_dataplex_integration" {
  description = "Enable database Dataplex integration"
  type        = bool
  default     = false
}

variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_plans_per_minute  = optional(number, 5)
    query_string_length     = optional(number, 1024)
    record_application_tags = optional(bool, false)
    record_client_address   = optional(bool, false)
  })
  default = null
}
