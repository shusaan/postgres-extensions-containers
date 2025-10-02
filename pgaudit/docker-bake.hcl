variable "REGISTRY" {
  default = "ghcr.io/cloudnative-pg"
}

variable "PG_VERSION" {
  default = "18"
}

variable "PGAUDIT_VERSION" {
  default = ""
}

variable "DISTRO" {
  default = "bookworm"
}

target "pgaudit" {
  dockerfile = "../Dockerfile"
  tags = [
    "${REGISTRY}/pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${formatdate("YYYYMMDDHHMM", timestamp())}-${DISTRO}",
    "${REGISTRY}/pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${DISTRO}",
    "${REGISTRY}/pgaudit:${regex("[0-9]+", PG_VERSION)}-${PGAUDIT_VERSION}-${DISTRO}"
  ]
  args = {
    PG_VERSION = PG_VERSION
    DISTRO = DISTRO
  }
}