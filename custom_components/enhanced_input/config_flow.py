from homeassistant import config_entries
import voluptuous as vol

DOMAIN = "enhanced_input"
CONF_MAX_TEXT_LENGTH = "max_text_length"
DEFAULT_MAX_TEXT_LENGTH = 2000


class EnhancedInputConfigFlow(config_entries.ConfigFlow, domain=DOMAIN):
    async def async_step_user(self, user_input=None):
        existing_entry = self._async_current_entries()
        if existing_entry:
            return self.async_abort(reason="already_configured")
        if user_input is not None:
            return self.async_create_entry(title="Enhanced Input", data={})

        return self.async_show_form(step_id="user", data_schema=vol.Schema({}))

    @staticmethod
    def async_get_options_flow(config_entry):
        return EnhancedInputOptionsFlow(config_entry)


class EnhancedInputOptionsFlow(config_entries.OptionsFlow):
    def __init__(self, config_entry):
        self.config_entry = config_entry

    async def async_step_init(self, user_input=None):
        if user_input is not None:
            return self.async_create_entry(title="", data=user_input)

        current_max = self.config_entry.options.get(
            CONF_MAX_TEXT_LENGTH, DEFAULT_MAX_TEXT_LENGTH
        )
        schema = vol.Schema(
            {
                vol.Optional(
                    CONF_MAX_TEXT_LENGTH,
                    default=current_max,
                ): vol.All(vol.Coerce(int), vol.Range(min=1)),
            }
        )
        return self.async_show_form(step_id="init", data_schema=schema)
