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
    public class BiologiesController : ApiController
    {
        private articlesEntities db = new articlesEntities();

        // GET: api/Biologies
        [AllowAnonymous]
        public IQueryable<Biology> GetBiology()
        {
            return db.Biology;
        }

        // GET: api/Biologies/5
        [AllowAnonymous]
        [ResponseType(typeof(BiologyArticles))]
        public IHttpActionResult GetBiologyArticles(int id)
        {
            BiologyArticles biologyArticles = db.BiologyArticles.Find(id);
            if (biologyArticles == null)
            {
                return NotFound();
            }

            return Ok(biologyArticles);
        }

        // PUT: api/Biologies/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutBiology(int id, Biology biology)
        {

            if (id != biology.ID)
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
                    $"EXEC BiologyRating @id = '{biology.ID}'," +
                    $" @rating = '{biology.Rating}'";
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

        // POST: api/Biologies
        [ResponseType(typeof(Biology))]
        public IHttpActionResult PostBiology(Biology biology)
        {

            db.Biology.Add(biology);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (BiologyExists(biology.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = biology.ID }, biology);
        }

        // DELETE: api/Biologies/5
        [ResponseType(typeof(Biology))]
        public IHttpActionResult DeleteBiology(int id)
        {
            Biology biology = db.Biology.Find(id);
            if (biology == null)
            {
                return NotFound();
            }

            db.Biology.Remove(biology);
            db.SaveChanges();

            return Ok(biology);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool BiologyExists(int id)
        {
            return db.Biology.Count(e => e.ID == id) > 0;
        }
    }
}