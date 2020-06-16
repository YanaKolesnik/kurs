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
    public class FishController : ApiController
    {
        private articlesEntities db = new articlesEntities();

        [AllowAnonymous]
        // GET: api/Fish
        public IQueryable<Fish> GetFish()
        {
            return db.Fish;
        }

        [AllowAnonymous]
        // GET: api/Fish/5
        [ResponseType(typeof(FishArticles))]
        public IHttpActionResult GetFishArticles(int id)
        {
            FishArticles fishArticles = db.FishArticles.Find(id);
            if (fishArticles == null)
            {
                return NotFound();
            }

            return Ok(fishArticles);
        }

        // PUT: api/Fish/5
        [AllowAnonymous]
        [ResponseType(typeof(void))]
        public IHttpActionResult PutFish(int id, Fish fish)
        {

            if (id != fish.ID)
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
                    $"EXEC FishRating @id = '{fish.ID}'," +
                    $" @rating = '{fish.Rating}'";
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

        // POST: api/Fish
        [ResponseType(typeof(Fish))]
        public IHttpActionResult PostFish(Fish fish)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Fish.Add(fish);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (FishExists(fish.ID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = fish.ID }, fish);
        }

        // DELETE: api/Fish/5
        [ResponseType(typeof(Fish))]
        public IHttpActionResult DeleteFish(int id)
        {
            Fish fish = db.Fish.Find(id);
            if (fish == null)
            {
                return NotFound();
            }

            db.Fish.Remove(fish);
            db.SaveChanges();

            return Ok(fish);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool FishExists(int id)
        {
            return db.Fish.Count(e => e.ID == id) > 0;
        }
    }
}