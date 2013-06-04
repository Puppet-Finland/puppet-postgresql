#
# == Class: postgresql::config
#
# Configure postgresql. Currently only covers setting up authentication setups 
# of services using postgresql as their database backend.
#
class postgresql::config {
    include postgresql::config::auth
}
