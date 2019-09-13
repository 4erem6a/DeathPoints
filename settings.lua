data:extend({
  {
    name = "deathpoints-pattern",
    type = "string-setting",
    setting_type = "runtime-global",
    default_value = "[color=red]DeathPoint:[/color] [color=green]$player[/color] died at [color=yellow]$time[/color]"
  },
  {
    name = "deathpoints-destroy_expired",
    type = "bool-setting",
    setting_type = "runtime-per-user",
    default_value = true
  },
  {
    name = "deathpoints-notify_on_expiration",
    type = "bool-setting",
    setting_type = "runtime-per-user",
    default_value = true
  }
})