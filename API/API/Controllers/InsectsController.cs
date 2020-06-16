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
    public class InsectsController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Insects
        public IQueryable<Insects> GetInsects()
        {
            return db.Insects;
        }
        [AllowAnonymous]
        // GET: api/Insects/5
        [ResponseType(typeof(InsectsArticles))]
        public IHttpActionResult GetInsectsArticles(int id)
        {
            InsectsArticles insectsArticles = db.InsectsArticles.Find(id);
            if (insectsArticles == null)
            {
                return NotFound();
            }

            return Ok(insectsArticles);
        }

        // PUT: api/Insects/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutInsects(int id, Insects insects)
        {

            if (id != insects.ID)
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
                    $"EXEC InsectsRating @id = '{insects.ID}'," +
                    $" @rating = '{insects.Rating}'";
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

        // POST: api/Insects
        [ResponseType(typeof(Insects))]
        public IHttpActionResult PostInsects(Insects insects)
        {

            db.Insects.Add(insects);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (InsectsExists(insects.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = insects.ID }, insects);
        }

        // DELETE: api/Insects/5
        [ResponseType(typeof(Insects))]
        public IHttpActionResult DeleteInsects(int id)
        {
            Insects insects = db.Insects.Find(id);
            if (insects == null)
            {
                return NotFound();
            }

            db.Insects.Remove(insects);
            db.SaveChanges();

            return Ok(insects);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool InsectsExists(int id)
        {
            return db.Insects.Count(e => e.ID == id) > 0;
        }
    }
}