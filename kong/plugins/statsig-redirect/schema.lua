return {
  name = "statsig-redirect",
  fields = {
    {
      config = {
        type = "record",
        fields = {
          { api_key = { type = "string", required = true } },
          { gate_name = { type = "string", required = true } },
          { url_true = { type = "string", required = true } },
          { url_false = { type = "string", required = true } },
        },
      },
    },
  },
}
