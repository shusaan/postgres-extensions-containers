variable "REGISTRY" {
  default = "ghcr.io"
}



variable "PG_VERSION" {
  default = "18"
}

variable "PGAUDIT_VERSION" {
  default = ""
}

variable "DISTROS" {
  default = ["bookworm", "trixie"]
}

variable "DISTRO" {
  default = "bookworm"
}

variable "BRANCH_NAME" {
  default = ""
}

target "pgaudit" {
  dockerfile = "../Dockerfile"
  tags = [
    "${REGISTRY}/pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${formatdate("YYYYMMDDHHMM", timestamp())}-${DISTRO}",
    "${REGISTRY}/pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${DISTRO}"
  ]
  args = {
    PG_VERSION = PG_VERSION
    DISTRO = DISTRO
    PGAUDIT_VERSION = PGAUDIT_VERSION
  }
}

target "pgaudit-feature" {
  dockerfile = "../Dockerfile"
  tags = [
    "${REGISTRY}/pgaudit:${PG_VERSION}-${PGAUDIT_VERSION}-${BRANCH_NAME}-${DISTRO}"
  ]
  args = {
    PG_VERSION = PG_VERSION
    DISTRO = DISTRO
    PGAUDIT_VERSION = PGAUDIT_VERSION
  }
}

# Matrix builds for PG 18 with multiple distros
group "pgaudit-all" {
  targets = [
    "pgaudit-18-bookworm",
    "pgaudit-18-trixie"
  ]
}

target "pgaudit-18-bookworm" {
  inherits = ["pgaudit"]
  args = {
    PG_VERSION = "18"
    DISTRO = "bookworm"
    PGAUDIT_VERSION = PGAUDIT_VERSION
  }
}

target "pgaudit-18-trixie" {
  inherits = ["pgaudit"]
  args = {
    PG_VERSION = "18"
    DISTRO = "trixie"
    PGAUDIT_VERSION = PGAUDIT_VERSION
  }
}