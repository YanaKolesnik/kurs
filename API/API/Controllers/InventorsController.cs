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
    public class InventorsController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Inventors
        public IQueryable<Inventors> GetInventors()
        {
            return db.Inventors;
        }
        [AllowAnonymous]
        // GET: api/Inventors/5
        [ResponseType(typeof(InventorsArticles))]
        public IHttpActionResult GetInventorsArticles(int id)
        {
            InventorsArticles inventorsArticles = db.InventorsArticles.Find(id);
            if (inventorsArticles == null)
            {
                return NotFound();
            }

            return Ok(inventorsArticles);
        }

        // PUT: api/Inventors/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutInventors(int id, Inventors inventors)
        {

            if (id != inventors.ID)
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
                    $"EXEC InventorsRating @id = '{inventors.ID}'," +
                    $" @rating = '{inventors.Rating}'";
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

        // POST: api/Inventors
        [ResponseType(typeof(Inventors))]
        public IHttpActionResult PostInventors(Inventors inventors)
        {

            db.Inventors.Add(inventors);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (InventorsExists(inventors.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = inventors.ID }, inventors);
        }

        // DELETE: api/Inventors/5
        [ResponseType(typeof(Inventors))]
        public IHttpActionResult DeleteInventors(int id)
        {
            Inventors inventors = db.Inventors.Find(id);
            if (inventors == null)
            {
                return NotFound();
            }

            db.Inventors.Remove(inventors);
            db.SaveChanges();

            return Ok(inventors);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool InventorsExists(int id)
        {
            return db.Inventors.Count(e => e.ID == id) > 0;
        }
    }
}