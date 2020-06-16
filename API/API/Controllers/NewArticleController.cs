using API.Data;
using API.Filters;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace BasicAuthentication.Controllers
{
    public class NewArticle
    {
        public string point { get; set; }
        public string imageLink { get; set; }
        public string header { get; set; }
        public string text { get; set; }
    }
    public class NewArticleController : ApiController
    {
        UsersDbContext db = new UsersDbContext();

        // POST: api/NewArticle
        [HttpPost]
        public IHttpActionResult AddAdmin(NewArticle newArticle)
        {
            string procedure = "";
            int number;
            string connectionString = @"Data Source=DESKTOP-RDKB255\SQLEXPRESS;Initial Catalog=articles;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                switch (newArticle.point)
                {
                    case "Биология":
                        {
                            procedure = "BiologyProcedure";
                            break;
                        }
                    case "География":
                        {
                            procedure = "GeographyProcedure";
                            break;
                        }
                    case "История":
                        {
                            procedure = "HistoryProcedure";
                            break;
                        }
                    case "Математика":
                        {
                            procedure = "MathematicsProcedure";
                            break;
                        }
                    case "Физика":
                        {
                            procedure = "PhysicsProcedure";
                            break;
                        }
                    case "Актеры":
                        {
                            procedure = "ActorsProcedure";
                            break;
                        }
                    case "Изобретатели":
                        {
                            procedure = "InventorsProcedure";
                            break;
                        }
                    case "Писатели":
                        {
                            procedure = "WritersProcedure"; 
                            break;
                        }
                    case "Рыбы":
                        {
                            procedure = "FishProcedure";
                            break;
                        }
                    case "Птицы":
                        {
                            procedure = "BirdsProcedure";
                            break;
                        }
                    case "Насекомые":
                        {
                            procedure = "InsectsProcedure";
                            break;
                        }
                    case "Звери":
                        {
                            procedure = "WildProcedure";
                            break;
                        }
                    case "Динозавры":
                        {
                            procedure = "DinoProcedure";
                            break;
                        }
                    case "Космос":
                        {
                            procedure = "SpaceProcedure";
                            break;
                        }
                    case "Игры":
                        {
                            procedure = "GamesProcedure";
                            break;
                        }
                    case "Технологии":
                        {
                            procedure = "TechnologiesProcedure";
                            break;
                        }
                }
                string commandStr =
                    $"EXEC {procedure} @link = '{newArticle.imageLink}'," +
                    $" @header = '{newArticle.header}', @text = '{newArticle.text}'";
                connection.Open();
                SqlCommand command = new SqlCommand(commandStr, connection);
                number = command.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                return BadRequest(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            if (number != null)
                return Ok();
            return BadRequest();
        }


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}