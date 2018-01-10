<?php

/**
 * @file
 * Enables modules and site configuration for a standard site installation.
 */

// Include only when in install mode. MAINTENANCE_MODE is defined in
// core/install.php and in drush_core_site_install().
if (defined('MAINTENANCE_MODE') && MAINTENANCE_MODE == 'install') {
  include_once 'seed.install.inc';
}
