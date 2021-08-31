using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Azure.Messaging.ServiceBus;
using Azure.Security.KeyVault.Secrets;
using Azure.Storage.Blobs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Azure;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace dotnet_web
{
    public class Startup
    {
        private readonly IConfiguration configuration;

        public Startup(IConfiguration configuration)
        {
            this.configuration = configuration;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddAzureClients(builder =>
            {
                builder.AddBlobServiceClient(configuration.GetSection("storageacc:blob"));
                builder.AddServiceBusClient(configuration.GetSection("serviceBus"));
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(
            IApplicationBuilder app,
            IWebHostEnvironment env,
            BlobServiceClient blobServiceClient,
            ServiceBusClient serviceBusClient)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapGet("/", async context =>
                {
                    context.Response.ContentType = "text/plain";
                    // Access storage
                    var containerClient = blobServiceClient.GetBlobContainerClient("uploads");
                    await containerClient.CreateIfNotExistsAsync();
                    await context.Response.WriteAsync($"Created container {containerClient.Uri}" + Environment.NewLine);

                    // Use service bus
                    var sender = serviceBusClient.CreateSender("Items");
                    await sender.SendMessageAsync(new ServiceBusMessage("Hello!"));
                    await context.Response.WriteAsync($"Send message to ServiceBus: {serviceBusClient.FullyQualifiedNamespace}");
                });
            });
        }
    }
}
