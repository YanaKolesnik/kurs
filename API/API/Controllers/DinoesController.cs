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
    public class DinoesController : ApiController
    {
        private articlesEntities db = new articlesEntities();

        [AllowAnonymous]
        // GET: api/Dinoes
        public IQueryable<Dino> GetDino()
        {
            return db.Dino;
        }


        [AllowAnonymous]
        public IHttpActionResult GetDinoArticles(int id)
        {
            DinoArticles dinoArticles = db.DinoArticles.Find(id);
            if (dinoArticles == null)
            {
                return NotFound();
            }

            return Ok(dinoArticles);
        }


        // PUT: api/Dinoes/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutDino(int id, Dino dino)
        {

            if (id != dino.ID)
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
                    $"EXEC DinoRating @id = '{dino.ID}'," +
                    $" @rating = '{dino.Rating}'";
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

        // POST: api/Dinoes
        [ResponseType(typeof(Dino))]
        public IHttpActionResult PostDino(Dino dino)
        {

            db.Dino.Add(dino);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (DinoExists(dino.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = dino.ID }, dino);
        }

        // DELETE: api/Dinoes/5
        [ResponseType(typeof(Dino))]
        public IHttpActionResult DeleteDino(int id)
        {
            Dino dino = db.Dino.Find(id);
            if (dino == null)
            {
                return NotFound();
            }

            db.Dino.Remove(dino);
            db.SaveChanges();

            return Ok(dino);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool DinoExists(int id)
        {
            return db.Dino.Count(e => e.ID == id) > 0;
        }
    }
}