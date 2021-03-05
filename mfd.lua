local inspect = require "inspect"
local htmlparser = require "htmlparser"
local glue = require "glue"

local curlCmdTemplate = "curl -s -L %s"
local curlCmdDownloadFileTemplate = "curl %s -o %s"

local curlCmdStream = assert(io.popen(curlCmdTemplate:format(arg[1]), "r"))
local htmlString = curlCmdStream:read('*all')
curlCmdStream:close()

local root = htmlparser.parse(htmlString)

local elements = root("#downloadButton")

for _, e in pairs(elements) do
    local downloadLink = e.attributes.href
    local splitUrl = glue.string.split(downloadLink, "/")
    local fileName = splitUrl[#splitUrl]
    os.execute(curlCmdDownloadFileTemplate:format(downloadLink, fileName))
end
