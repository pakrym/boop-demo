using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace FunctionApp
{
    public static class Function1
    {
        [FunctionName("Function1")]
        public static void Run(
            [ServiceBusTrigger("items", Connection = "serviceBus")] string data, ILogger logger)
        {
            logger.LogInformation("Message content {data}", data.ToString());
        }
    }
}
