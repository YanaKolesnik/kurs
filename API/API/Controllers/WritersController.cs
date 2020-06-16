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
    public class WritersController : ApiController
    {
        private articlesEntities db = new articlesEntities();

        // GET: api/Writers
        [AllowAnonymous]
        public IQueryable<Writers> GetWriters()
        {
            return db.Writers;
        }

        // GET: api/Writers/5
        [AllowAnonymous]
        [ResponseType(typeof(WritersArticles))]
        public IHttpActionResult GetWritersArticles(int id)
        {
            WritersArticles writersArticles = db.WritersArticles.Find(id);
            if (writersArticles == null)
            {
                return NotFound();
            }

            return Ok(writersArticles);
        }

        // PUT: api/Writers/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutWriters(int id, Writers writers)
        {

            if (id != writers.ID)
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
                    $"EXEC WritersRating @id = '{writers.ID}'," +
                    $" @rating = '{writers.Rating}'";
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

        // POST: api/Writers
        [ResponseType(typeof(Writers))]
        public IHttpActionResult PostWriters(Writers writers)
        {

            db.Writers.Add(writers);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (WritersExists(writers.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = writers.ID }, writers);
        }

        // DELETE: api/Writers/5
        [ResponseType(typeof(Writers))]
        public IHttpActionResult DeleteWriters(int id)
        {
            Writers writers = db.Writers.Find(id);
            if (writers == null)
            {
                return NotFound();
            }

            db.Writers.Remove(writers);
            db.SaveChanges();

            return Ok(writers);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool WritersExists(int id)
        {
            return db.Writers.Count(e => e.ID == id) > 0;
        }
    }
}