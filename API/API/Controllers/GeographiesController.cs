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
    public class GeographiesController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Geographies
        public IQueryable<Geography> GetGeography()
        {
            return db.Geography;
        }
        [AllowAnonymous]
        // GET: api/Geographies/5
        [ResponseType(typeof(GeographyArticles))]
        public IHttpActionResult GetGeographyArticles(int id)
        {
            GeographyArticles geographyArticles = db.GeographyArticles.Find(id);
            if (geographyArticles == null)
            {
                return NotFound();
            }

            return Ok(geographyArticles);
        }

        // PUT: api/Geographies/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutGeography(int id, Geography geography)
        {

            if (id != geography.ID)
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
                    $"EXEC GeographyRating @id = '{geography.ID}'," +
                    $" @rating = '{geography.Rating}'";
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

        // POST: api/Geographies
        [ResponseType(typeof(Geography))]
        public IHttpActionResult PostGeography(Geography geography)
        {
            db.Geography.Add(geography);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (GeographyExists(geography.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = geography.ID }, geography);
        }

        // DELETE: api/Geographies/5
        [ResponseType(typeof(Geography))]
        public IHttpActionResult DeleteGeography(int id)
        {
            Geography geography = db.Geography.Find(id);
            if (geography == null)
            {
                return NotFound();
            }

            db.Geography.Remove(geography);
            db.SaveChanges();

            return Ok(geography);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool GeographyExists(int id)
        {
            return db.Geography.Count(e => e.ID == id) > 0;
        }
    }
}