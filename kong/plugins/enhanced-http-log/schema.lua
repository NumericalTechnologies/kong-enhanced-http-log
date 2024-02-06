local Schema = require "kong.db.schema"
local typedefs = require "kong.db.schema.typedefs"

local config_schema = Schema.define {
    type = "record",
    fields = {
      {
        http_endpoint = {
          type = "string",
          description = "A string representing a URL, such as https://example.com/path/to/resource?q=search."
        },
        {
          method = {
            description =
            "An optional method used to send data to the HTTP server. Supported values are `POST` (default), `PUT`, and `PATCH`.",
            type = "string",
            default = "POST",
            one_of = { "POST", "PUT", "PATCH" }
          }
        },
        {
          content_type = {
            description = "Indicates the type of data sent. The only available option is `application/json`.",
            type = "string",
            default = "application/json",
            one_of = {
              "application/json",
              "application/json; charset=utf-8"
            }
          }
        },
        {
          timeout = {
            description = "An optional timeout in milliseconds when sending data to the upstream server.",
            type = "number",
            default = 10000
          }
        },
        {
          keepalive = {
            description =
            "An optional value in milliseconds that defines how long an idle connection will live before being closed.",
            type = "number",
            default = 60000
          }
        },
        {
          retry_count = {
            description = "Number of times to retry when sending data to the upstream server.",
            type = "integer"
          }
        },
        {
          queue_size = {
            description = "Maximum number of log entries to be sent on each message to the upstream server.",
            type = "integer"
          }
        },
        {
          flush_timeout = {
            description =
            "Optional time in seconds. If `queue_size` > 1, this is the max idle time before sending a log with less than `queue_size` records.",
            type = "number"
          }
        },
        {
          headers = {
            description =
            "An optional table of headers included in the HTTP message to the upstream server. Values are indexed by header name, and each header name accepts a single string.",
            type = "map",
            keys = {
              type = "string",
              description = "A string representing an HTTP header name."
            },
            values = { type = "string", referenceable = true }
          }
        },
        {
          queue = {
            type = "record",
            fields = {
              {
                max_batch_size = {
                  type = "integer",
                  default = 1,
                  between = { 1, 1000000 },
                  description = "Maximum number of entries that can be processed at a time."
                }
              }, {
              max_coalescing_delay = {
                type = "number",
                default = 1,
                between = { 0, 3600 },
                description =
                "Maximum number of (fractional) seconds to elapse after the first entry was queued before the queue starts calling the handler."
                -- This parameter has no effect if `max_batch_size` is 1, as queued entries will be sent
                -- immediately in that case.
              }
            }, {
              max_entries = {
                type = "integer",
                default = 10000,
                between = { 1, 1000000 },
                description = "Maximum number of entries that can be waiting on the queue."
              }
            }, {
              max_bytes = {
                type = "integer",
                default = nil,
                description = "Maximum number of bytes that can be waiting on a queue, requires string content."
              }
            }, {
              max_retry_time = {
                type = "number",
                default = 60,
                description = "Time in seconds before the queue gives up calling a failed handler for a batch."
                -- If this parameter is set to -1, no retries will be made for a failed batch
              }
            }, {
              initial_retry_delay = {
                type = "number",
                default = 0.01,
                between = { 0.001, 1000000 },                         -- effectively unlimited maximum
                description = "Time in seconds before the initial retry is made for a failing batch."
                -- For each subsequent retry, the previous retry time is doubled up to `max_retry_delay`
              }
            }, {
              max_retry_delay = {
                type = "number",
                default = 60,
                between = { 0.001, 1000000 },                         -- effectively unlimited maximum
                description = "Maximum time in seconds between retries, caps exponential backoff."
              }
            }
            }
          }
        },
        {
          custom_fields_by_lua = {
            type = "map",
            keys = { type = "string", len_min = 1 },
            values = { type = "string", len_min = 1 },
            description = "Lua code as a key-value map"
          }
        }
      }
    }
  
}

return {
  name = "enhanced-http-log",
  fields = {
    { protocols = typedefs.protocols_http },
    { config = config_schema }
  }
}
