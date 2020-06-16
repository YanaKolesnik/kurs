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
    public class WildsController : ApiController
    {
        private articlesEntities db = new articlesEntities();
        [AllowAnonymous]
        // GET: api/Wilds
        public IQueryable<Wild> GetWild()
        {
            return db.Wild;
        }
        [AllowAnonymous]
        // GET: api/Wilds/5
        [ResponseType(typeof(WildArticles))]
        public IHttpActionResult GetWildArticles(int id)
        {
            WildArticles wildArticles = db.WildArticles.Find(id);
            if (wildArticles == null)
            {
                return NotFound();
            }

            return Ok(wildArticles);
        }

        // PUT: api/Wilds/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutWild(int id, Wild wild)
        {

            if (id != wild.ID)
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
                    $"EXEC WildRating @id = '{wild.ID}'," +
                    $" @rating = '{wild.Rating}'";
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

        // POST: api/Wilds
        [ResponseType(typeof(Wild))]
        public IHttpActionResult PostWild(Wild wild)
        {

            db.Wild.Add(wild);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (WildExists(wild.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = wild.ID }, wild);
        }

        // DELETE: api/Wilds/5
        [ResponseType(typeof(Wild))]
        public IHttpActionResult DeleteWild(int id)
        {
            Wild wild = db.Wild.Find(id);
            if (wild == null)
            {
                return NotFound();
            }

            db.Wild.Remove(wild);
            db.SaveChanges();

            return Ok(wild);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool WildExists(int id)
        {
            return db.Wild.Count(e => e.ID == id) > 0;
        }
    }
}