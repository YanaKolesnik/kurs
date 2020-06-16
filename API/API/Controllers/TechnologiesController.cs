using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using API.Filters;
using BasicAuthentication;

namespace BasicAuthentication.Controllers
{
    public class TechnologiesController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Technologies
        public IQueryable<Technologies> GetTechnologies()
        {
            return db.Technologies;
        }
        [AllowAnonymous]
        // GET: api/Technologies/5
        [ResponseType(typeof(TechnologiesArticles))]
        public IHttpActionResult GetTechnologiesArticles(int id)
        {
            TechnologiesArticles technologiesArticles = db.TechnologiesArticles.Find(id);
            if (technologiesArticles == null)
            {
                return NotFound();
            }

            return Ok(technologiesArticles);
        }

        // PUT: api/Technologies/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutTechnologies(int id, Technologies technologies)
        {

            if (id != technologies.ID)
            {
                return BadRequest();
            }

            string procedure = "";
            int number;
            string connectionString = @"Data Source=DESKTOP-RDKB255\SQLEXPRESS;Initial Catalog=articles;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                string commandStr =
                    $"EXEC TechnologiesRating @id = '{technologies.ID}'," +
                    $" @rating = '{technologies.Rating}'";
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

            return null;
        }

        // POST: api/Technologies
        [ResponseType(typeof(Technologies))]
        public IHttpActionResult PostTechnologies(Technologies technologies)
        {

            db.Technologies.Add(technologies);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (TechnologiesExists(technologies.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = technologies.ID }, technologies);
        }

        // DELETE: api/Technologies/5
        [ResponseType(typeof(Technologies))]
        public IHttpActionResult DeleteTechnologies(int id)
        {
            Technologies technologies = db.Technologies.Find(id);
            if (technologies == null)
            {
                return NotFound();
            }

            db.Technologies.Remove(technologies);
            db.SaveChanges();

            return Ok(technologies);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool TechnologiesExists(int id)
        {
            return db.Technologies.Count(e => e.ID == id) > 0;
        }
    }
}