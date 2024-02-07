local typedefs = require "kong.db.schema.typedefs"

return {
  name = "enhanced-http-log",
  fields = {
    { protocols = typedefs.protocols },
    {
      config = {
        type = "record",
        fields = {
          {
            http_endpoint = {
              type = "string"
            }
          },
          {
            method =
            {
              type = "string",
              default = "POST",
              one_of = { "POST", "PUT", "PATCH" },
            },
          },

          {
            content_type =
            {
              type = "string",
              default = "application/json",
              one_of = { "application/json", "application/json; charset=utf-8" },
            },
          },
          {
            timeout =
            {
              type = "number",
              default = 10000
            },
          },
          {
            keepalive =
            {
              type = "number",
              default = 60000
            },
          },
          {
            retry_count =
            {
              type = "integer"
            },
          },
          {
            queue_size =
            {
              type = "integer"
            },
          },
          {
            flush_timeout =
            {
              type = "number"
            },
          },
          {
            headers = {
              type = "map",
              keys =
              {
                type = "string",
              },
              values =
              {
                type = "string",
              },
            }
          },
          {
            queue = {
              type = "record",
              fields = {
                {
                  max_batch_size =
                  {
                    type = "integer",
                    default = 1,
                    between = { 1, 1000000 },
                  }
                },
                {
                  max_coalescing_delay =
                  {
                    type = "number",
                    default = 1,
                    between = { 0, 3600 },
                  }
                },
                {
                  max_entries =
                  {
                    type = "integer",
                    default = 10000,
                    between = { 1, 1000000 },
                  }
                },
                {
                  max_bytes =
                  {
                    type = "integer",
                    default = nil,
                  }
                },
                {
                  max_retry_time =
                  {
                    type = "number",
                    default = 60,
                  }
                },
                {
                  initial_retry_delay =
                  {
                    type = "number",
                    default = 1,
                    between = { 1, 1000000 }, -- effectively unlimited maximum
                  }
                },
                {
                  max_retry_delay =
                  {
                    type = "number",
                    default = 60,
                    between = { 1, 1000000 }, -- effectively unlimited maximum
                  }
                }
              }
            }
          },
          {
            custom_fields_by_lua = {
              type = "map",
              keys =
              {
                type = "string",
                len_min = 1
              },
              values =
              {
                type = "string",
                len_min = 1
              },
            }
          }
        },
      },
    },
  },
}
